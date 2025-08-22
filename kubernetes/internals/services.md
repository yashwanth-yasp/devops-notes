---
date: 2025-08-21
tags:
  - ust
  - devops
  - kubernetes
---

- ClusterIP
  - clusterIP is completly in cluster 
  - anything in a cluster can contact any other things in the cluster that has a clusterIP 
  - you can talk to the clusterIP's name and it will reroute it to the given service if you are trying to reach it form within the cluster
  - cluster IP has a target port on the deployment it's trying to reach and it's own port 
  - if you don't mention the node port it will be conntected to, kubernetes will find a port that is free in all the machines and assigns that port 
- NodePort
  - it has an external port that is reachable from outside the cluster 
  - if you are asking for a node port, all machines need to have that port is empty or else it won't allow you to create that node port 
  - when you are creating a nodeport, you have to mention the clusterIP it will be connected to
- Loadbalancer 
  - It gives the loadbalancer a public IP 

--- 

- The communication between two containers in the same pod is possible cause of linux kernel as it is in the same namespace 
- The communication between two containers in two different pods happens though cbr 
  - the request is routed from docker contianer to pod's eth0 and then to cbr 
- The communication between two containers in two different machines can be done through the network plugin 
  - the request is routed from cbr to the network plugin and the network plugin will handle the delivery of that 
  - the network plugin has the information of cidr range of all the worker nodes cause it is done when teh worker nodes are joining to the cluster 
- **"kubernetes will keep working if all master nodes are down as long as no container crashes or any machine fails"**
- the communication between an external device and something in the node (service basically)
  - whenever a service name or cluster ip is hit, the cbr routes it to kube-proxy as it's written in each machines iptable
  - kube-proxy will always keep talking to the api-server to get the pods associated with the service 
  - as service reroutes it to the pods with the lable associated with it, so it needs to contact the etcd to find what pods have that label, so the kube-proxy always needs to keep checking with the api-server 
  - once the kube-proxy gets hit for the service, it does denatting and changes the address to the pod ip and sends it back to cbr and the cbr sends it to the network plugin 

- calico nework plugin 
  - ip in ip 
    - when seding a message to IP 1 which is a service that routes to IP 2, calico will wrap that message that has service ip with another message as two address
    - the network plugin is able to reach the ip in the other machine cause it knows that all IPs in a particular CIDR range is associated with a machine and routes it to that machine 
    - ip in ip allows the message to go back to the machine 
    - the ip in ip is just an example and even simple NATing and DeNATing can be done 

- DNS
  - every request from the pod is routed to the core-dns nameserver and it is so cause it is written in the /etc/resolv.conf that core-dns IP is the dns server 
  - we can't reach the dns through the host machine cause it's resolv.conf has a different dns which is linked to whatever provider's dns server. An aws ec2 instance would have aws domain name server written in that file

