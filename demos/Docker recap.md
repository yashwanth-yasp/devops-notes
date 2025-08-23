---
date: 2025-08-22
tags:
  - devops
  - ust
  - docker
---

- What is Docker? 
	- _Docker_ is a platform designed to help developers build, share, and run container applications.

# Containers 

A container in the context of software is ==a standardized unit of software that packages an application's code, runtime, system tools, system libraries, and settings, enabling it to run consistently across different computing environments==.

- But what is it actually? 
- Docker container is just a process isolated with ==linux namespaces and cgroups== 

- What happens when you run the docker run command?

![[Pasted image 20250822210152.png]]

(if the image doesn't load in markdown, it will be in the same folder, please refer to it)

- when you run the docker run command, the client sends the command to docker daemon 
- docker daemon calls the low level container runtime containerd 
- containerd in turn calls runc 
- runc creates the namespaces and cgroups necessary for the container process isolation 

- Let's test this 

```bash
docker run -d --name d0 alpine sleep 1000

docker inspect d0 | grep Pid # shows pid of hte first process of the container 

ps -fp <PID>

ls -l /proc/<PID>/ns

ps -ef | grep runc
```

- We can also get into the namespace and test it 

```bash
nsenter --target <PID> --uts --ipc --net --pid --mount sh
```

- Verifying cgrups in docker 

```bash
cd /proc/<PID>

cat cgroup
```

# Images 

- A Docker image is a read-only template containing an application and all its dependencies, including libraries, binaries, and other necessary files, packaged together to ensure consistent execution across different environments
- NOT to be confused with Dockerfiles 
- Dockerfiles are a template that would create an image 
- And Image is an actual built product, it is a layered file system 
- Docker uses the Overlay file system that allow copy-on-write 

```Dockerfile
FROM ubuntu:22.04

RUN mkdir /layer2 && \
    echo "file A from layer2" > /layer2/fileA.txt && \
    echo "file B from layer2" > /layer2/fileB.txt

RUN mkdir /layer3 && \
    echo "file C from layer3" > /layer3/fileC.txt && \
    echo "file D from layer3" > /layer3/fileD.txt

RUN mkdir /layer4 && \
    echo "file E from layer4" > /layer4/fileE.txt && \
    echo "file F from layer4" > /layer4/fileF.txt
```

```bash
docker run -it --name ovctr overlay-demo bash
```

```bash
echo "MODIFIED in container" > /layer2/fileA.txt

# this location is the Upper layer directory of this container
docker inspect -f '{{.GraphDriver.Data.UpperDir}}' ovctr
```

# Volumes 

- Docker containers are ephemeral - they can die any time 
- If you don't want docker containers to crash, attach volumes
- docker volume types 
	- tmpfs
		- In-memory, wiped when container stops.
		- when you attach a tmpfs to a container, it will only stay till the containers is present 
		- When you add more data, the writable layer gets big and that will slow it's runtime down when you stop and start that container 
	- bind mounts 
	    - giving a path in the host machine, it can anywhere in the host machine
	- volumes
		- anonymous volumes 
		- named volumes 

- why are bind mounts bad?
	- The disadvantage with bind mount is that there is a security risk cause you can attach the container to any point in the host machine
	- Critical folders like /proc can also be attached which is a security risk 

# Networking


![[docker-networking-flow.png]]

(if the image doesn't load, it will be in the same demos folder, please refer to it)

```bash
docker run -dit --name c1 alpine sh
docker run -dit --name c2 alpine sh
```

```bash
docker exec c1 ip a
```

```bash
ip link | grep veth
```

```bash
brctl show
```

```bash
docker network create mynet
docker run -dit --name x1 --network mynet alpine sh
docker run -dit --name x2 --network mynet alpine sh
docker exec x1 ping -c2 x2 # notice something here?
```

```bash
brctl show
```

- how does x1 reach x2 with just the container name?
	- Every Docker network (bridge, overlay, etc.) has its own small DNS resolver. This runs _inside the Docker daemon process_, not as a separate container.
# Interesting questions

- **Why does docker default to root in any container on a fresh install?**
- **You run a container with -p 8080:80. How does Docker actually expose that port?**
- **How does ping work with docker container name?**
- **What happens if two containers in different networks have the same name? Which one does DNS resolve?**
- **How does Docker ensure two containers mounting the same volume don’t corrupt data?**
- **What happens inside the Docker daemon when you `docker exec` into a running container?

# Best Practices 

- Images 
	- Keep Images minimal - As less layers as possible 
		- Combine similar layers to reduce the number of layers 
	- Change Image versions with every update or use some unique identifier like a git sha in a CI for clean versioning 
	- Multi-stage builds
		- Use multi-stage Dockerfiles to separate build-time dependencies from runtime.
	- Layer Caching
		- Order Dockerfile instructions so that frequently changing parts are at the bottom.
		- Because if say you have `requirements.txt` file that changes frequently, then it's better to copy that and install before we copy the main app directory, as any change in the app directory would still mean the before layers are valid 
		- So it's better to add `requirement.txt` and `pip install` before that, then the layers can be cached and not be rebuilt
	- Containers 
		- One process per container → Stick to single responsibility
		- Limit resources → Use `--memory`, `--cpus` to avoid noisy-neighbor problems.
	- Volumes 
		- Use named volumes for persistance 
		- Use anonymous volumes when you need it to be connected to only one container 
	- Networking 
		- Isolate networks → Separate microservices from each other 
		- Be mindful of published ports → Only expose what’s needed
	- Security 
		- Least privilege principle -> Use user-namespace remapping to secure folders
		- instead of ADD, it is suggested to use RUN curl or RUN wget instead of ADD for internet access as it can be combined with other RUN commands 
		- for local during building COPY can be used instead of ADD
		- Trivy scanning
		- Creating users
		- Clean cache 
	- Performance 
		- Stateless apps in containers 
		- Healthchecks


 
