---
date: 2025-08-29
tags:
  - ust
  - devops
  - kubernetes
  - security
---

- If you want to control traffic flow at the IP address or port level (OSI layer 3 or 4), NetworkPolicies allow you to specify rules for traffic flow within your cluster, and also between Pods and the outside world. Your cluster must use a network plugin that supports NetworkPolicy enforcement.

# Important notes 

- Make sure to have dns in egress for all the entities that is trying to reach a kubernetes service 
- Make sure to have 0.0.0.0/0 in all service egress that is trying to reach an external service such as an AI service like Bedrock 
- Make sure to have 0.0.0.0/0 in ingress of any service that needs to be accessed by the local machine and the ones that are not using a proxy 

