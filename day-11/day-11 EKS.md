---
date: 2025-08-04
tags:
  - ust
  - devops
  - aws
  - eks
---

- Amazon Elastic Kubernetes Service (EKS) is a fully managed Kubernetes service that makes it easy to run Kubernetes on AWS without needing to install, operate, and maintain your own Kubernetes control plane or nodes.
- EKS has
	- Managed Control plane 
	- High Availability 
	- Security 
	- Scalability 
	- Integration 
- Core Components 
	- Control Plane 
		- Managed by AWS
		- Runs across multiple AZs
	- Data Plane 
		- EC2 instances 
		- Can be managed via node-groups or self-managed 

![[Pasted image 20250805234153.png]]

- The remaning is the practical of how you would deploy an image using EKS which is mentioned in [[Deploying custom image on EKS]]

