
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

