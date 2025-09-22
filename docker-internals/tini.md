---
date: 2025-09-17
tags:
  - ust
  - devops
  - docker
  - tini
---

`tini` is a very small and simple **init system** designed specifically for use in containers.

It's important because it correctly handles process management and signal forwarding, which are critical for running applications robustly inside a container.

---
## The Problem `tini` Solves

In a normal Linux operating system, the first process to run is the "init" system (like `systemd` or `sysvinit`), which has a special Process ID (PID) of 1. This PID 1 process has two crucial responsibilities:

1. **Reaping Zombie Processes**: If a process creates a child process and then dies, the child becomes an "orphan." The init system "adopts" this orphan and cleans it up properly when it eventually exits. If this doesn't happen, the child becomes a "zombie"—a dead process that still takes up space in the system's process table. 🧟
    
2. **Forwarding Signals**: The init system receives shutdown signals (like `SIGTERM` from a `docker stop` command) and ensures they are passed along to the running applications so they can shut down gracefully.
    

When you run an application directly in a Docker container (e.g., `ENTRYPOINT ["gunicorn", ...]`), your application becomes PID 1. However, most applications aren't built to handle these special responsibilities.

This leads to two major issues:

- **Zombie Apocalypse**: If your Gunicorn server spawns worker processes and some die unexpectedly, they can become zombies that never get cleaned up, slowly leaking system resources.
    
- **Improper Shutdown**: When you run `docker stop`, Docker sends a `SIGTERM` signal to PID 1 inside the container. If your application doesn't correctly handle and forward this signal to its children, it won't shut down gracefully. Docker will wait for a timeout period (usually 10 seconds) and then forcibly kill it with a `SIGKILL`, which can corrupt data or interrupt connections.
    

---

## How `tini` Fixes It

`tini` is designed to be the perfect PID 1. In your script, the `ENTRYPOINT` is configured to run `tini` first, which then launches your Gunicorn server.

`ENTRYPOINT ["/usr/bin/tini", "--", "gunicorn", "--bind=0.0.0.0:5001", "app:app"]`

By doing this:

1. **`tini` becomes PID 1**.
    
2. `tini` starts Gunicorn as a child process.
    
3. `tini` **forwards all signals** it receives to the Gunicorn process, ensuring `docker stop` results in a graceful shutdown.
    
4. `tini` **reaps any zombie processes** created by Gunicorn, preventing resource leaks.

In short, including `tini` makes your container more stable, robust, and well-behaved, just like an application running on a traditional server.