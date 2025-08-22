---
date: 2025-08-21
tags:
  - ust
  - devops
  - kubernetes
---

- Ingress is a kubernetes resource that manages external path based routing to services inside your cluster
- You can't create load-balancers for each microservice as it would be costly, AWS alone has around thousands of microservices, we cannot create that many microservices 
- The solution to it is Ingress
- Ingress will allow you to do path based routing 
- clusterIP does the routing between instances of the same microservice type but Ingress decides which microservice to go 
- When you hit the service IP of the ingress, the service routes it to the controller pod which has all the ingress rules which will route the path to the given service while also carrying the path and appending it to the service IP


