---
date: 2025-08-22
tags:
  - ust
  - devops
  - kubernetes
---

- Probes 
	- How will kubernetes know that if the application is running on the container?
	- Container is running doesn't mean the applicaiton is running 
		- sometimes the startup scripts will take time and the container is still in running state but that doesn't mean the application is running 
	- Kubernetes uses probes to check if the application is running
	- probes keep hitting it even if it successdes with some period  
	- Types 
		- Liveness
			- You check if the application is live 
			- you can verify the presence of some file that could tell you if hte application is live
			- you would do cat that fiel and if that appears then you are good 
			- you can probe the health endpoint or send a tcp request
			- you have independence to do it however you want accoridng to application 
			- When liveness prove fails, the pod is recreated but the readiness probe waits 
		- Readiness 
			- Readiness probe waits 
		- Startup 
			-  Statrtup probe verifies whether the application within a container is started. 

|                   |                                                                                                 |                                                                                     |                                                       |
| ----------------- | ----------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------- | ----------------------------------------------------- |
| Feature           | Startup Probe                                                                                   | Liveness Probe                                                                      | Readiness Probe                                       |
| Primary Goal      | Checks if the application has finished starting up.                                             | Checks if the application is still running (alive).                                 | Checks if the application is ready to accept traffic. |
| When it Runs      | Runs only at the beginning of the container's lifecycle. It is disabled as soon as it succeeds. | Runs continuously throughout the container's life after the startup probe succeeds. | Runs continuously throughout the container's life.    |
| Action on Failure | Restarts the container based on the pod's restart policy.                                       | Restarts the container.                                                             | Stops sending traffic to the container.               |

