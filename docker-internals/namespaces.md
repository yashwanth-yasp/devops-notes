---
date: 2025-08-21
tags:
  - ust
  - devops
  - docker
---

- How do you differentiate two machines?
  - Network space 
    - like ip, ports opened, sockets etc
    - using these we can differentiate between two devices 
  - User space 
    - if you create a user in a machine, the same user wouldn't be in the other machine 
  - File system space 
    - If you create a file in one machine, the other machine wouldn't have that 
  - Process space 
    - The processes running on one machine wouldn't be in a different machine 
  - Hostname space 
    - Two machines have different hostnames 
  - Inter-process communication 
    - two processes in the same machine communicate using IPC 
    - if two processes are communitcating through two different machines, it is using RPC 
- Linux kernal has a way in which you can create a new file system space and attach a process to it 
- So docker uses this linux feature to create namespaces to get independant file structure, network space etc. 
- And yeah docker natively runs only on linux machines 
- Docker uses linux cgroups to monitor the resources used by a container because it is technically a process and shuts down something if it exceeds the limit they set. 


