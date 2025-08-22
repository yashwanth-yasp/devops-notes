---
date: 2025-08-21
tags:
  - ust
  - devops
  - docker
---

- Docker by default only runs if the user is in the docker group 
- If not go to root and run docker 
- process id 1 is very critical 
  - when you start a container, the process id 1 would be whatever the image builder has decided 
  - if it's not mentioned it will be whatever the user says
  - writeable layer is in overlay2
  - writable layer can be found in graph driver section of container inspect

