---
date: 2025-07-28
tags:
  - ust
  - devops
  - kubernetes
  - github
---
![[Pasted image 20250728172049.png]]

# Github Actions Self-hosted Runners 

- Method 1: Using Actions Runner Controller (ARC)
	- Actions Runner Controller is the official Kubernetes operator for GitHub Actions runners.
- Method 2: Custom Docker Image Approach
	- You can create a docker image for the special runner 

# GitLab CI Runner 

- Using the Official GitLab Runner Helm Chart
	- Gitlab provides an official runner helm chart that we can use 

# Jenkin Agents

- We can install kubernetes plugin in jenkins and can use that to create a self runner 

# Security Considerations

- Several security considerations needs to be made before deploying the workflows
	- Setting up network policies 
	- Setting up pod security standards 
	- Setting up secrete management files 

# Monitoring and Scaling

- Prometheus Metrics
- Custom Resource Definitions for Scaling

- The text isn't much as the I don't understand the prerequistes, I will update this file after I find out more about this 


