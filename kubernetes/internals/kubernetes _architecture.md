---
date: 2025-08-21
tags:
  - ust
  - devops
  - kubernetes
---

- Kubernetes Architecture 
  - Master node
    - Kubelet is talking to Master Node api server and is sending the status of pods and other kubernetes kinds and the status is then stored in etcd 
    - ETCD 
      - stateful cause it's a storage
      - etcd stores the data about all the stuff that is being created in etcd
      - All the info like the statuses of all the deployments, pods etc is stored in etcd 
      - so when you do `kubectl get po` or `kubectl get deployments`, the info is being taken from etcd 
      - etcd is a nosql database 
      - so by default it can scale horizontally 
    - api-server
      - it is completly stateless 
      - does Authentication and Authorization 
      - and talk to etcd to do all the create, update, delete operations 
    - kube-scheduler 
      - also stateless
      - works based on event-driven architecture 
      - it will run an algorithm which analyzes the node resources stored in etcd to find out which is the best node to create the pod
      - after it finds it out, it talks to the api-server and updates the etcd
    - kube-controller 
      - also stateless
      - any time when the desired state is not meeting the current state, controller will come into picture 
      - controller is always checking if everything is working properly and if something isn't it will fix it 
  - Worker node 
    - kubelet 
      - kubelet is the only service in the kubernetes architecture which is not a pod, it is a program 
      - It is the one sending the status of the worker node to the master node 
      - It is a program and not a pod because if the docker in the worker node fails or crashes, the master node needs to know about it but if it's a pod there is a chance even kubelet might fail, that is why this is a program and not a pod. 
      - It works with the container runtime like crio or containerd and create containers. 
    - kube-proxy
      - Runs on all the nodes and understands the networking of all the nodes
    - Containerd or CRIO 
      - creates container whenever kubelet commands it 

# In the case of Multiple masters and multiple worker nodes

- Each master can reach all worker nodes because the info is stored in the etcd and the master can access it 
- But if a worker wants to contact the master, it will go through the load balancer to reach the master as even the masters can be down 
- We don't want to bombard a single master to be bombarded, so to distribute the load we need a loadbalancer 
- And the master has info on the workers cause kubelet has been pinging the master that it's present 
- But kubelet can't reach master as the master isn't pinging the kubelet always, that's where load balancer comes in 

# Benifits 

- SEf organizing and automatic binpakcing 
- seamlessly deploy, update and rollback 
  - quck and predictable/consistent
- self healing
- service discovery and load balancing 
- volume management 
- storage orchestration 
- optimum hardware utilization 
- Batch Execution 
- Improved security through RBAC and Network policies 
- Ingress helps path based routing 
