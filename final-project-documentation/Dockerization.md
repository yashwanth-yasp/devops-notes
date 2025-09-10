---
date: 2025-08-28
tags:
  - ust
  - devops
  - docker
  - project
---
# Highlights 

- Usage of libcap-2-bin library and the setcap command to give non-root-user access to previliged ports which would be inaccessible by default 
- Usage of **PYTHONDONTWRITEBYTECODE=1** and **PYTHONUNBUFFERED=1** env variable to remove .pyc files saving space and for logging the stderr and stdout
- Creating wheels for the python requirements in build stage and using that to install the dependencies in the run time 
- Usage of ARGS such as BUILDPLATFORM and TARGET_ARCH for .Net dockerfiles to allow modification to it during docker build 
- Usage of npm ci instead of npm install to only download production dependencies saving space 
# Vote Dockerfile 

```Dockerfile
# Build Stage
FROM python:3.11-slim AS builder

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /usr/src/app

COPY requirements.txt .
RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential gcc && \
    pip install --upgrade pip && \
    pip wheel --no-cache-dir --no-deps -r requirements.txt -w /wheels && \
    apt-get purge -y build-essential gcc && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Runtime Stage
FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PATH="/home/appuser/.local/bin:$PATH"

WORKDIR /usr/local/app

# Install runtime deps + create user
RUN apt-get update && \
    apt-get install -y --no-install-recommends libpq-dev libcap2-bin && \
    rm -rf /var/lib/apt/lists/* && \
    useradd -ms /bin/bash appuser

# Copy wheels and app source code
COPY --from=builder /wheels /wheels
COPY . .

# Install wheels + set ownership
RUN pip install --no-cache /wheels/* && \
    rm -rf /wheels && \
    chown -R appuser:appuser /usr/local/app && \
    setcap 'cap_net_bind_service=+ep' /usr/local/bin/python3.11

USER appuser

EXPOSE 80

ENTRYPOINT ["gunicorn", "app:app", "-b", "0.0.0.0:80"]
```

## Explaination 

- Stage-1: Builder Stage
	- Uses a **slim image** to reduce size.
	- A separate **build stage** keeps build tools (like `gcc`) out of the final image.
	- **PYTHONDONTWRITEBYTECODE=1** → avoids writing `.pyc` files → saves space.
	- **PYTHONUNBUFFERED=1** → logs go directly to stdout/stderr → better for Docker logging.
	- Copies only `requirements.txt` first → improves **layer caching** (dependencies don’t reinstall unless requirements change).
	- Installs compilers only for this stage.
	- Builds **wheels** for dependencies (compiled packages). 
	- Removes compilers to keep the builder stage lean.
	- Using `--no-install-recommends` keeps unnecessary packages out.
	- Cleans up apt cache to save space.
- Stage-2: Runtime Stage
	- Final runtime is based on **slim Python** → small, fast, secure.
	- Same optimizations as builder stage.
	- Adds user-local bin path to `PATH` for non-root installs.
	- Installs only **runtime dependencies** (`libpq-dev` for PostgreSQL support, `libcap2-bin` for setting network capabilities).
	- Creates a **non-root user (`appuser`)** → security best practice.
	- Copies pre-built wheels from builder stage.
	- Copies the app source code.
	- Installs dependencies from wheels (fast + reproducible).
	- Cleans up wheels after installation.
	- Sets file ownership to `appuser`.
	- **`setcap`** allows Python to bind to low-numbered ports (like port 80) without running as root → secure + convenient.
	- Runs the container as `appuser` instead of `root` → reduces attack surface.
	- Uses Entrypoint instead of CMD to remove the chance of a attacker able to access a command interface.

# Worker Dockerfile

```Dockerfile
# STAGE 1: Build the application

FROM --platform=${BUILDPLATFORM} mcr.microsoft.com/dotnet/sdk:7.0 AS build

# Optional build-time args for logging/debug
ARG TARGETPLATFORM
ARG TARGETARCH
ARG BUILDPLATFORM

# Just for visibility in CI logs
RUN echo "Building on ${BUILDPLATFORM}, targeting ${TARGETPLATFORM} (${TARGETARCH})"

WORKDIR /src

# Copy csproj and restore dependencies (better layer caching)
COPY *.csproj ./
RUN dotnet restore -a ${TARGETARCH}

# Copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o /app -a ${TARGETARCH} --self-contained false --no-restore



# STAGE 2: Runtime image (minimal & secure)
FROM mcr.microsoft.com/dotnet/runtime:7.0

# Using a non root user for better security 
RUN useradd -m appuser
USER appuser

WORKDIR /app
COPY --from=build /app .

# environment variables (can be overridden at runtime)
ENV DOTNET_EnableDiagnostics=0 \
    DOTNET_GCHeapHardLimit=0 \
    DOTNET_GCHeapHardLimitPercent=75 \
    DOTNET_GCTieredCompilation=1

ENTRYPOINT ["dotnet", "Worker.dll"]
```


- Stage-1: Build Stage
	- Uses the **.NET SDK image** (needed for build/restore/publish).
	- `--platform=${BUILDPLATFORM}` makes this work in **multi-arch builds** (e.g., building ARM64 images on an x86 CI runner).
	- Build-time arguments for **cross-compilation** and logging.
	- ARG allows modifications of those arguments when doing docker build
	- `TARGETARCH` is later used for `dotnet restore` and `dotnet publish`.
	- The `echo` is just for **visibility in CI/CD logs**, helps debugging.
	- Copies only the project file first → leverages **Docker layer caching** (dependencies don’t re-download unless `.csproj` changes).
	- Runs `dotnet restore` to fetch NuGet packages.
	- Copies the full source after restoring dependencies.
	- `dotnet publish` produces an **optimized, trimmed build** into `/app`.
	- `--self-contained false` → assumes the runtime will be available in the base image (keeps image size smaller than a self-contained one).
	- `--no-restore` avoids restoring twice since we already did `dotnet restore`.
- Stage-2: Rutime Stage
	- Uses the **lightweight runtime-only image** (no SDK → much smaller & more secure).
	- This separation is a best practice: **SDK for build, runtime for execution**.
	- Creates a **non-root user** (`appuser`).
	- Runs the app as non-root → reduces container attack surface.
	- `-m` ensures a home directory is created (useful if the app writes to `$HOME`).
	- Copies the published binaries from the builder stage.
	- Keeps final image clean (no source code, no SDK).
	- `DOTNET_EnableDiagnostics=0` → disables diagnostic tools/profilers → improves perf & security
	- `DOTNET_.GCHeapHardLimit=0` & `DOTNET_GCHeapHardLimitPercent=75` → let the GC auto-tune memory usage, but restrict to ~75% of container memory.
	- `DOTNET_GCTieredCompilation=1` → enables JIT tiered compilation → better startup + runtime perf.
	- Uses `ENTRYPOINT` (not `CMD`) so the container always runs the app by default.

# Result Dockerfile 

```Dockerfile
FROM node:18-slim

# Install tini + libcap
RUN apt-get update && \
    apt-get install -y --no-install-recommends tini libcap2-bin && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

# Copy package files + source
COPY package*.json ./
COPY . .

# Install deps, create user, set ownership
RUN npm ci --only=production && npm cache clean --force && \
    addgroup --system appgroup && adduser --system --ingroup appgroup appuser && \
    chown -R appuser:appgroup /usr/src/app && \
    setcap 'cap_net_bind_service=+ep' /usr/local/bin/node

USER appuser

ENV NODE_ENV=production \
    PORT=80
EXPOSE 80

ENTRYPOINT ["/usr/bin/tini", "--", "node", "server.js"]
```

- Uses the official **Node.js v18 slim image** (Debian-based but stripped down to reduce size).
- Slim means fewer preinstalled tools → smaller image, but you need to install some basics manually.
- `tini`: a lightweight **init system** that properly handles zombie processes and signal forwarding. (Prevents issues when Docker stops/restarts the container).
- `libcap2-bin`: gives you the `setcap` utility, which lets you grant Linux capabilities to processes (used later for binding to port 80 without root).
- `rm -rf /var/lib/apt/lists/*`: cleans up package lists → keeps the image smaller.
- Sets Working Directory
- First copies `package.json` and `package-lock.json` (if present).
- Then copies the full source code into `/usr/src/app`.
- Best practice would normally copy package files first, run `npm ci`, then copy source (for better layer caching), but here everything is copied together.
- Switches to the non-root user (`appuser`) created earlier.
- Improves **security** — prevents container escape vulnerabilities from running as root.
- Sets environment variables:
    - `NODE_ENV=production`: tells Node and frameworks (like Express) to optimize for production.
    - `PORT=80`: default port for the app.
- Declares that the container will listen on port 80.
- Informational for tools like Docker/Kubernetes (doesn’t actually publish it).
- Uses `tini` as the entrypoint → makes sure signals are handled properly (e.g., `docker stop` sends SIGTERM, tini forwards it to Node).
- Runs `node server.js` as the main process.

# AI analyzer Dockerfile

```Dockerfile
# Use slim Python base image
FROM python:3.9-slim

# Install security updates + dependencies for gunicorn/psycopg2/etc.
RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential curl tini && \
    rm -rf /var/lib/apt/lists/*

# Set workdir
WORKDIR /app

# Copy dependency file first (for layer caching)
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copy app source
COPY . .

# Create non-root user for security
RUN addgroup --system appgroup && adduser --system --ingroup appgroup appuser && \
    chown -R appuser:appgroup /app
USER appuser

# Environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PORT=5001

# Expose port
EXPOSE 5001

ENTRYPOINT ["/usr/bin/tini", "--", "gunicorn", "--bind=0.0.0.0:5001", "app:app"]
```

- Uses the **official Python 3.9 slim image**.
- “Slim” = Debian-based but minimal → smaller image size, but you need to install build tools if required.
- `build-essential`: needed for compiling native dependencies (e.g., psycopg2 for Postgres).
- `curl`: handy for debugging or health checks. (I think k8s probes midht not need this but I need to check)
- `tini`: lightweight **init system** to handle zombie processes & signal forwarding (important in Docker).
- `rm -rf /var/lib/apt/lists/*`: cleans apt metadata → keeps the image small.
- Sets `/app` as the working directory
- Copies only `requirements.txt` into the image.
- This is a **best practice** → dependency layer can be cached if your requirements haven’t changed, so rebuilding is faster.
- Upgrades pip itself.
- Installs all Python dependencies listed in `requirements.txt`.
- `--no-cache-dir` prevents caching of packages, keeping the image smaller.
- Creates a non-root group (`appgroup`) and user (`appuser`).
- Changes ownership of `/app` so `appuser` can read/write where needed.
- Switches to run the container as `appuser` → improves security by avoiding root.
- `PYTHONUNBUFFERED=1`: ensures logs are output immediately (not buffered) → useful for Docker logging.
- `PYTHONDONTWRITEBYTECODE=1`: stops Python from creating `.pyc` files → keeps the container clean.
- `PORT=5001`: defines the app’s listening port.
- Declares that the app listens on port 5001.
- Informational for Docker/Kubernetes (doesn’t actually open the port).
- Uses `tini` as the entrypoint (like in your Node Dockerfile) → handles signals & zombies properly.
- Runs **Gunicorn** as the app server:
    - `--bind=0.0.0.0:5001`: listens on all interfaces, port 5001.
    - `app:app`: tells Gunicorn to look for `app` (the Flask/FastAPI/Django WSGI object) inside the `app.py` file.

