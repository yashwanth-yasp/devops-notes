---
date: 2025-08-05
tags:
  - ust
  - devops
  - aws
---

- ECS eliminates the need to install and operate your own container orchestration software, manage and scale a cluster of virtual machines, or schedule containers on those virtual machines.
- Key Concepts 
	- Cluster
		- A logical grouping of tasks or services. Clusters can contain tasks running on EC2 instances, Fargate, or a mix of both.
	- Task Definition 
		- Blueprint of how a container should run and includes stuff like the docker images, CPU and memory requirements, port mappings etc
	- Task 
		- Running instance of a task definition
		- A task can have one or more containers 
	- Service 
		- Ensures a specified number of tasks are running and replaces unhealthy tasks. Services provide load balancing and service discovery.
- The main difference between EKS and ECS is EKS is highly dependent on kubernetes and allows exporting of a cluster created in EKS while ECS is highly dependent on AWS and doesn't need Kubernetes knowlege to operate, it is known to be fairly simple 
- I will rewrite the code and best practices later