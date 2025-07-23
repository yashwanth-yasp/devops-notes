---
date: 2025-07-21
tags:
  - docker
  - devops
  - ust
---


- A Dockerfile is like a recipe that tells Docker how to build your application into a container. Think of it as step-by-step instructions that Docker follows to create an image of your app

- Important instructions
	- **FROM** - Choose your base image
	- **WORKDIR** - Set your working directory
	- **COPY** - Copy files from your computer to the container
	- **RUN** - Execute commands during the build
	- **EXPOSE** - Tell Docker which port your app uses
	- **CMD** - What command to run when the container starts

# Writing efficient docker files 

- Choosing the right image 
	- there are alternatives for the base images that are much smaller 
	- **Why slim/alpine images?**
		- Regular images: ~800MB
		- Slim images: ~200MB
		- Alpine images: ~50MB
- Clean up after installing packages

```Dockerfile
# **Bad** - leaves package manager cache
RUN apt-get update && apt-get install -y git

# Good - cleans up after installation
RUN apt-get update && apt-get install -y git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/
```

- Use dockerignore file
	- similar to gitignore and ignores folders or files in the image

```dockerignore
node_modules
.git
.env
*.log
README.md
```

- Layer efficientlly
	- Docker builds in layers, it reuses the layers that are not changed while building an image, so layer in such a way that the layers that change the least are at the top

```Dockerfile
# Good order - dependencies change less often than your code
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
CMD ["python", "app.py"]
```

# Multi-Stage builds 

- Multi-stage builds let you use multiple FROM statements in one Dockerfile. This is like having a workshop to build something, then moving only the finished product to a clean room.

```Dockerfile
# Stage 1: Build stage
FROM node:18 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Stage 2: Runtime stage
FROM node:18-alpine
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
EXPOSE 3000
CMD ["node", "dist/index.js"]
```

- Real-World Example: Go Application

```Dockerfile
# Build stage
FROM golang:1.21-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN go build -o main .

# Runtime stage
FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /app/main .
CMD ["./main"]
```

# Advanced optimization techniques

- Use distroless images
	- Distroless images contain only your application and its runtime dependencies:

```Dockerfile
# Build stage
FROM golang:1.21-alpine AS builder
WORKDIR /app
COPY . .
RUN go build -o main .

# Runtime stage with distroless
FROM gcr.io/distroless/static-debian11
COPY --from=builder /app/main /
ENTRYPOINT ["/main"]

```

- Create a non-root user

```Dockerfile
FROM python:3.11-slim
RUN groupadd -r appuser && useradd -r -g appuser appuser
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
USER appuser
CMD ["python", "app.py"]

```

- Using secrets for sensitve data

```Dockerfile
# Don't copy sensitive files directly
RUN --mount=type=secret,id=api_key \
    API_KEY=$(cat /run/secrets/api_key) python setup.py
```

- Use alternatives that are faster, uv for pip and npm ci for node.js for example

![[Pasted image 20250721172254.png]]

![[Pasted image 20250721172327.png]]

