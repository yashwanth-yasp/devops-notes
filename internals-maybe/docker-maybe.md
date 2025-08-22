
# Docker 

- **What happens when you execute docker run ubuntu:latest echo 'hello'**
  - When docker run command is run, the docker client contacts the docker daemon and send it the command
  - The daemon checks if the image is present locally, if not it will pull it from docker hub
    - Docker uses content-addressable storage, meaning each layer is identified by a unique cryptographic hash of its content. This ensures layers are shared between images to save space.
  - Container Creation    
    - The daemon creates a new container. It takes all the image layers and stacks them on top of each other and creates a thin writable layer above it. 
    - This copy-on-write mechanism is incredibly efficient; the container only writes new data or modifications to the top layer, leaving the underlying image layers untouched.
    - And copy-on-write also ensures that the file is loaded only when there is a modification in that file, for example if you make changes in /etc/resolv.conf, then only that file is copied up from the earliest layer it's present and is modified however needed 
    - To provide isolation, the daemon creates a set of Linux namespaces for the container. This includes a PID namespace (so the container sees only its own processes, with the echo command as PID 1), a NET namespace (giving it a private network stack), a MNT namespace (a private view of the filesystem), and others (UTS, IPC, User). 
    - To control resource usage, the daemon creates a control group (cgroup) for the container. This is used to enforce limits on CPU, memory, and I/O that you might specify.
  - The daemon uses the echo 'hello' command as the starting process (PID 1) inside the new namespaces and cgroup. The process runs, prints "hello" to the standard output, and then exits.
  - Since the main process has exited, the container stops. The writable layer is preserved but is no longer running.


- **What are linux namespaces and cgroups and why are they fundamental to how docker works?**
  - Linux Namespaces are a kernel feature that provides isolation. They virtualize system resources for a process, making it seem like it has its own dedicated instance of that resource.
  - For docker, the key namespaces are 
    - PID (Process ID): Isolates the process tree. A container can't see or affect processes outside its namespace.
    - NET (Network): Isolates network interfaces, IP addresses, and ports. This is why every container gets its own IP address.
    - MNT (Mount): Isolates filesystem mount points. This ensures a container has its own root filesystem and can't see the host's file structure.
    - UTS: Isolates the hostname.
    - IPC: Isolates inter-process communication resources.
    - User: Maps users inside the container to different users outside, enhancing security.
  - Control Groups (cgroups) are a kernel feature that provides resource limiting. They allow you to allocate and restrict the amount of system resources (like CPU, memory, network bandwidth, and disk I/O) that a process or group of processes can use.
  - They are fundamental cause namespaces provides the isolation necessary for the container to run as if it's a seperate machine, and cgroups allow monitoring of these containers to manage them. 


- **From a technical, file-system perspective, what is the key difference between an image and a container?**
  - An image is a collection of read-only layers. Each layer represents a set of file changes. They are stacked on top of each other using a Union File System. An image is inert and cannot be changed.
  - A container is the combination of the read-only image layers plus a single, thin, writable layer on top. All changes made during the container's life—creating new files, modifying existing ones, deleting files—are written to this top writable layer. This is the copy-on-write mechanism in action. When you delete a container, only this writable layer is destroyed; the underlying image remains untouched.

- **You run a container with -p 8080:80. How does Docker actually expose that port?**
  - Docker manipulates the host's networking rules using a tool called iptables (the standard Linux firewall). Here's how:
  - When you use -p 8080:80, the Docker daemon creates a new rule in the DOCKER chain of the nat table in iptables.
  - This rule specifies that any incoming traffic on any network interface (0.0.0.0) destined for port 8080 should have its destination address translated.
  - This is a Destination Network Address Translation (DNAT) rule. The destination is changed from the host's IP and port 8080 to the container's private IP address (e.g., 172.17.0.2) and port 80.
  - The kernel's networking stack then routes the packet to the Docker container. When the container replies, iptables performs the reverse translation on the source address so the external client sees the reply as coming from the host server.

- **Why would you choose a bridge network versus an overlay network?**
  - You use a bridge network for communication between containers on a single host. It's the default and is simple and efficient for standalone applications or multi-container apps (like with Docker Compose) running on one machine. The Docker daemon creates a virtual bridge (like docker0) on the host, and all containers on that network are connected to it, allowing them to communicate via their private IPs.
  - You use an overlay network for communication between containers running across multiple hosts in a cluster (like Docker Swarm or Kubernetes). It solves the problem of multi-host networking by creating a virtual, distributed Layer 2 network that is "overlaid" on top of the host machines' networks. It uses an encapsulation protocol like VXLAN to wrap the container's network traffic in packets that can be routed between the hosts, making it seem as if all containers are on the same, single network, regardless of which physical machine they are on.


- **Why are Docker Volumes the preferred way to persist data over bind mounts?**
  - Docker Volumes are preferred over bind mounts for several key reasons, all related to abstraction and management:
  - Managed by Docker: Volumes are created and managed by the Docker daemon. You can create, list, and remove them using Docker commands. Bind mounts are just arbitrary paths from the host filesystem, which Docker knows nothing about.
  - Decoupling from Host: Volumes are stored in a dedicated area on the host filesystem (e.g., /var/lib/docker/volumes/), but their exact location is an implementation detail. This decouples the container's data from the host's directory structure. With a bind mount, you are tightly coupled to a specific path on the host, which makes the container less portable.
  - Security and Permissions: Docker can automatically manage the permissions and ownership of files in a volume, which can be a major headache with bind mounts, especially when the user IDs inside and outside the container don't match.
  - Portability and Drivers: Volumes support volume drivers, allowing you to store data on remote hosts, cloud providers (like AWS EBS), or network file systems (NFS), which is impossible with bind mounts.
  - Easier to Backup and Migrate: Because they are managed objects, it's simpler to script the backup, restoration, and migration of Docker volumes.

- **Why does docker default to root in any container on a fresh install?**
  - At the end of the day, docker container is a process in the linux kernal, if it wants to access a bind mount, tmfs or a volume, this "process" needs to have permission for it, this is what we modify when we mention "ro" and "rw" while adding volumes 
  - But say docker assumes a non-root user and you create a bind mount in the directory of another non-root user, now due to the mismatch of UIDs, docker will not be able to access it's bind mounts, that is why it defaults to root when you start. 
  - This can be changed by carefully modifying the permissions 
