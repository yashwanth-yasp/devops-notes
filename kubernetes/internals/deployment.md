---
date: 2025-08-21
tags:
  - ust
  - devops
  - kubernetes
---

# Deployments 

- Deployment creates Replica set internally which further creates pods 
- When a deployment is added to the etcd by the api-server, the deployment controller starts and makes an entry in the etcd for a replica set and the replica set controller is triggered which further and makes an entry to the etcd for the required no of pods. 
- When a version update is made in the deployment, the controller will create a new replica set in the etcd wtih 0 count and after that it makes the desired count to `(previous deployment no)/2 + 1` or less than that, if the previous deployment version was 5, the new deployment replica set would be changed to 2. ANd then the replica set controller goes to etcd and updates 2 new pods. 
- After two new pods are set to running, the replica set reduces the previous deployment no by that much, so in this case 5 - 2 = 3. After that replica set will see that and will reduce the previous deployment count to 3. 
- so end user doesn' notice any change 
- And after that it will gradually increase the new deployment and reduce the count of the old deployment. 

