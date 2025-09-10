---
date: 2025-08-23
tags:
  - devops
  - ust
  - kubernetes
---
- These are packages of pre-configured Kubernetes resources. A chart includes all the necessary components for an application, such as deployments, services, volumes, and configuration files (like ConfigMaps and Secrets), defined in YAML manifests.
- It can be uploaded to a repository where other can access it 
- You will have to deploy microservices seperately which itself has so many things
- As you move from one dev stage to another, you will have to change stuff in yaml files which is difficult if you do one by one 
- Helm Architecture 
	- Helm Client 
		- Not actual customers but are those who are using the chart 

- Release is a running instance of a helm chart 
- In helm chart, you can create placeholders in yaml files through which you can make changes to all the files at once 
- Helm can be used in ci-cd 
- Helm basically creates a complete template for the kubernetes cluster 
- It's like react app create where it will create folders add file strucutres with some placeholder information 
- this does that for all the yaml files in the kubernetes cluster but can be changed always from the values.yaml file
- values.yaml files placeholers for all the fields in the yaml files which can be changed and all the yaml files would change 
- It's kind of like variables.tf file in terraform 
- There are simpler alternatives to this like Kustomize 

