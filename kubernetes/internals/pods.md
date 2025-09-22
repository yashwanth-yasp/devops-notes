---
date: 2025-08-21
tags:
  - ust
  - devops
  - kubernetes
---

- Pods are a group of one or more containers 
- Properties
  - Co-located - Containers of a single pod will always run on the same machine 
  - Co-scheduled - All the Containers in a pod will start at the same time 
  - Share Certain things 
    - Shares the same Network Space 
    - Shares the same filesytem space 
      - A docker volume for example 

- when you run `kubectl run ydgpod --image=nginx`
  - kubectl does a REST api request to the api server 
    - kubectl will convert the command to json format and send it to the api server 
    - it also sends the certificate 
      - the certificate is for authentication and authorization that the api-server does 
  - api-server 
    - It will get the request and does authentication, authorization and validation (checking if the request is valid, like request count check etc) and adds the json to the etcd 
  - kube-scheduler 
    - as soon as something is added to etcd, scheduler will come in and finds the best node to run this on and pings api-server to update it in etcd 
  - api-server 
    - then api-server will contact the kubelet of the node given by the scheduler 
  - the kubelet 
    - kubelet will hit the containerd or crio to create the container

- If at any point a container goes down, kubelet fixes it locally and it **replaces** the container with a new container
 - and it will immediately ping the api-server that container went down and it fixed it

