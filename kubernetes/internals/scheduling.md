---
date: 2025-08-21
tags:
  - ust
  - devops
  - kubernetes
---

# Scheduling 

- We can choose to create a pod on a node by metnioning nodeName while making the pod
  - the scheduler will not even get intiated and the api-server will directly talk to kubelet of that machine
- It can also choose a set of machines and the api-server can make it one of them 

# Taint 

- If you taint a node, any pod which you create will not go into that node 
- by default kubernetes will add a taint to the master node as it doesn't want any other node running there 
- that is the taint we removed to make it work in single machine 
- If a pod can tolerate "x" then it can be created in that node, then it can be created in it, it can also be created in nodes that don't have any taint, but if we can't tolerate "y", it can't be created on that node. 

- Three scenarios with Taint
  - NoSchedule
    - If it doesn't have toleration for it, then don't schedule
    -  Any pod that is being created, if it has a toleration for say "x = 1; NoSchedule" and the taint on that node is exactly that, only then it will be created 
    - But if there is already a pod that doesn't have that toleration in that node, then kubernetes will not mess with it and let it run
  - PreferNoSchedule
    - If it doesn't have toleration for it, prefer don't schedule 
    - But if there is a lot of load on the other nodes, then it's okay to create here
    - It will not mess with the ones that are already running 
  - NoExecute
    - It will not allow any pod without toleration, even the ones running, so no execute 
- Taint has three parameters 
  - has a key (key-value pair)
  - has a value (key-value pair)
  - one of the scenarios
 
 # Affinity

 - You can say a pod has an affinity to a pod with some percentage to a **node**, and according to that it is more likely that it will be created there 
 - You can also say a pod has an affiity to another **pod** with some percentage, and according to that it is more likely that it will be created in a node that has that pod.