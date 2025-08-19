
- Docker containers are ephemeral - they can die any time 
- If you don't want docker containers to crash, attach volumes


- Databases 
  - SQL 
    - table or schema format 
  - NoSQL
    - not table or schema
    - can be 
      - key value 
      - graph oriented 
      - wide column database
      - document oriented database 

- Applications should be designed to be stateless 
- But some applications need docker volumes 
  - A container which downloads data from a database, but if the container crashes, the download has to restart
  - The new container has no context so it checks the database and continues form the last record downloaded and continue from there 
  - But imagine someone deleted the last 100 faulty rows from the database directly 
  - Now the new container will refer the database and continues form the part afterr it's been delted, esssentialy re-downloading the faulty rows
  - but if you have a volume, this doesn't happen, as it can compare downloaded and the ones present and can infer that it was deleted from the database directly 

- All mounted volumes essentially act as a new folder in the system 

# Docker Volume Types

- docker volume types 
  - volumes
    - anonymous volumes 
    - named volumes 
  - bind mounts 
    - giving a path in the host machine, it can anywhere in the host machine
  - tmpfs

- Using docker volumes, two docker containers can communicate in real-time 

## Bind Mount 

- Creating bind mount

`docker run -it -v /home/ubuntu/host-volume:/home/ubuntu/container-volume ubuntu /bin/bash `

- This creates host-volume on host machine and container-volume in the container and binds them together 
- If any file is created in one of them, the other folder would also reflect 
- We can also crash this container and create a new nginx image and bind the host machine folder to a folder in the container and it would reflect the data 

`docker run -it -v /home/ubuntu/host-volume:/nginx-volume nginx bash`

- This creates a folder in the nginx containers root directory and binds it with the local folder in the host machine 
- Even if the folder already has content in it, it is still bound to the container and displayed in the container-folder 

- This can be tested by creating a mysql database in the container and crashing it and then checking it in the local machine, the database would still be present, the folder used is `/var/lib/mysql` as all the sql metadata is stored in that folder by default
- that folder from the container is bound to some folder in the host machine
- reference - [link](https://github.com/vilasvarghese/docker-k8s/blob/master/dockerfiles/frontEndAndBackEnd/webfrontend-mysqldb/instructions.txt)
- The disadvantage with bind mount is that there is a security risk cause you can attach the container to any point in the host machine
- Critical folders like /proc can also be attached which is a security risk 

## Volumes 

- Volumes solve the issue of bind mounts by allowing the volumes to be made only in the docker root directory 
- `docker run -v volume_name:/path-in-the-container nginx`
- three parameters can be written 
  - first is where on the host machine 
  - second is where inside the container 
  - third is access type 
    - it can be read only (ro) 
    - or it can be read write (rw)
- The slash after -v is what docker uses to differentiate between a bind mount and a volume 
- The only parameter that is mandatory is the second paramerter, so if you see only one parameter, it is the path in the container 
- In this case, the first parameter is not present, meaning the volume name or the host path is not mentioned, so the container creates a volume with a random name, this is called **anonymous volumes**
- If you give the volume a name, it is a **named volume**
- There is a command in the Docker Image called VOLUME
- So when you are creating a container from an Image which has a VOLUME defined, the container will have an anonymous volume attached 

## tmpfs

- Not supported in windows, only supported in linux
- Special type of volume and is also supported by kubernetes 
- when you attach a tmpfs to a container, it will only stay till the containers is present 
- It is used for temporary storage 
- When you add more data, the writable layer gets big and that will slow it's runtime down when you stop and start that container 
- Ex: Can be used as a temporary download folder in the example of a container downloading a database and storing it in the local database 
- `docker run --mount type=tmpfs source destination nginx`

- `docker system prune` will prune everything other than volumes

