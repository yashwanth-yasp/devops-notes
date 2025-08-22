---
tags:
  - ust
  - devops
  - docker
---

- images are layered file system
- image layers are stored in root directory overlay2
- The default storage driver is overlay2, that is why it is stored there, can be seen with `docker info`
- copy on write
  - image loads the bare minimum necesary
  - when something is necessary it loads form the upper most layer as it considers it as the latest
  - advantage: imporoves runtime performance by loading containers fast initially 
  - disadvantage: if there are too many layers, the container has to check all the layers to load the new data 
- reduce the no of layers to increase efficiency 
- copy and ADD are similar, can be used to copy stuff from host machine to the image in a Dockerfile
  - ADD can also be used for downloading something from the internet 
  - copy only copies from the local machine
  - but ADD is not advised cause it cannot be hacked to download a file 
  - If copy cannot download from internet, there is no vulnerability 
  - so instead of ADD, it is suggested to use RUN curl or RUN wget instead of ADD 
- this allows combining run layers into other RUN commands to reduce the no of layers in the image

