
- Main internals needed
  - Images [images](/docker-internals/docker_images.md)
  - Containers [containers](/docker-internals/theory.md)
  - Volumes [volumes](/docker-internals/volumes.md)
  - Networking [networking](/docker-internals/networking-basics.md)


- Docker is a process in the host machine, so how does it run a process inside it?
  - Every process inside the container is also a process in the host machine 
  - if you do ps -ef in the host machine, you will be able to see a process for each of the containers 
  - It is just an execution of the program is containerd
  - If it is a simple program how is it able to run another program in it
  - every process that is run on docker container is a child process in the view of hte host machine 
  - so when a container is stopped, the host machine's kernel takes care of the child processes and cleanes the child processes it up 
  - but if you kill the process with kill -9, then the child processes stay and be orphaned processes and it is cleaned up after the host restarts 

- If you kill a container which is technically a process, so if you kill it you shouldn't be able to get the changes you made while it's up, but you do get it, but how?
  - this is because, whatever you are doing get persisted by default
  - when you make changes to teh container, the image is not written cause it is read only, so it is not stored in the image
  - docker has a folder called the writeable layer 

