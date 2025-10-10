---
date: 2025-09-30
tags:
  - ust
  - devops
  - kubernetes
  - cka
---
# Deploy Issue 

- The deployment was not comming up 
- described the pod and saw that the configmap wasn't present
- saw what configmap was present in the system and did k edit deploy to change the name of the configmap being referenced

```bash
k -n application1 get deploy

k -n application1 logs deploy/api

k -n application1 describe deploy api

k -n application1 get cm
```

```bash
k -n application1 edit deploy api
```

# Referncing node name

- A _Deployment_ has been imported from another Kubernetes cluster. But it's seems like the _Pods_ are not running. Fix the _Deployment_ so that it would work in any Kubernetes cluster.
- I checked the logs of the pods, there were no events, meaning the pod was never scheduled adn it was pending state
- and when I did logs for the pod, we see that the deployment was looking for a node called "staging-node1" and the cluster didn't have any. 
- As this was imported from a different cluster, it might be that the previous cluster had a node like that. 
- As we have only control plane in this cluster, we can just remove that line
- Removed and it started scheduled


