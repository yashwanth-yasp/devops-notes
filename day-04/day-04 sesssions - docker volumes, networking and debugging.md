---
date: 2025-07-21
tags:
  - ust
  - devops
  - docker
---

- When you run a Docker container, any data you create inside it disappears when the container stops. This is called **ephemeral storage** - it's temporary and not persistent.

# Docker Volumes and Binding Mounts 

- There are two solutions to the ephemeral storage
	- Bind mounts
		- Creates a direct connection from a folder of the host machine to the container 
		- `docker run -v /home/user/myapp:/app myimage`
	- Docker Volumes
		- Volumes are like external hard drives that Docker manages for you. They're stored in a special Docker area on your computer.
		- This can be attached to any container 
		- The data stays even if you delete the container
		- `docker volume create database_data`
		- `docker run -v database_data:/var/lib/mysql mysql`

# Docker Networking 

- When you have multiple containers, they have to talk to each other to function as an application 
- The frontend container talking to backend container talking to the database container for example
- Types of Docker Networks 
	- Bridge Network (Default) 
		- This is like having a private network inside your computer where containers can talk to each other.
		-  `docker run -d --name app1 nginx`
		- `docker run -d --name app2 nginx`
		- Custom bridge network:
			- Only specified containers can communicate 
			- `docker network create my_network`
			- `docker run -d --name app1 --network my_network nginx`
			- `docker run -d --name app2 --network my_network nginx`
	- Host Network
		- The container uses your computer's network directly. It's like the container is running directly on your machine.
		- `docker run -d --network host nginx`
	- Overlay Network
		- Used when you have Docker containers running on multiple computers that need to communicate. This is advanced and used in production clusters.

![[Pasted image 20250723114959.png]]

# Docker Compose 

- Docker compose is basically putting all the long docker run commands in a single file and executing them at once 
- `docker compose -f sample_application.yml up`

```yaml
version: '3.8'

services:
  # Frontend React Application
  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
    ports:
      - "3000:3000"
    volumes:
      - ./frontend/src:/app/src  # Live reload during development
    depends_on:
      - backend
    environment:
      - REACT_APP_API_URL=http://localhost:5000

  # Backend Node.js API
  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile
    ports:
      - "5000:5000"
    volumes:
      - ./backend:/app
      - /app/node_modules  # Anonymous volume for node_modules
    depends_on:
      - database
      - redis
    environment:
      - NODE_ENV=development
      - DATABASE_URL=mongodb://database:27017/myapp
      - REDIS_URL=redis://redis:6379

  # MongoDB Database
  database:
    image: mongo:5.0
    ports:
      - "27017:27017"
    volumes:
      - mongodb_data:/data/db
    environment:
      - MONGO_INITDB_ROOT_USERNAME=admin
      - MONGO_INITDB_ROOT_PASSWORD=password

  # Redis Cache
  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data

  # Nginx Reverse Proxy
  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
    depends_on:
      - frontend
      - backend

volumes:
  mongodb_data:
  redis_data:

networks:
  default:
    name: myapp_network
```


# CI/CD Integration 

- Github workflows example
	- Create `.github/workflows/ci.yml`

```yaml
name: CI/CD Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v2
    
    - name: Build and test
      run: |
        docker-compose -f docker-compose.yml -f docker-compose.test.yml build
        docker-compose -f docker-compose.yml -f docker-compose.test.yml run --rm backend npm test
        docker-compose -f docker-compose.yml -f docker-compose.test.yml run --rm frontend npm test
    
    - name: Build production images
      run: |
        docker-compose -f docker-compose.prod.yml build
    
    - name: Push to registry
      run: |
        echo ${{ secrets.DOCKER_PASSWORD }} | docker login -u ${{ secrets.DOCKER_USERNAME }} --password-stdin
        docker-compose -f docker-compose.prod.yml push

```

- Production deployment 

```yaml
# docker-compose.prod.yml
version: '3.8'

services:
  frontend:
    build:
      context: ./frontend
      target: production
    restart: unless-stopped
    
  backend:
    build:
      context: ./backend
      target: production
    restart: unless-stopped
    environment:
      - NODE_ENV=production
```

# Deployment Best Practices 

- Use Multi-Stage Dockerfiles
- Environment-Specific Configuration
- Database Migrations

![[Pasted image 20250723120653.png]]



