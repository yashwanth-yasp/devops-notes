---
date: 2025-08-23
tags:
  - ust
  - devops
  - kubernetes
  - microservices
---
- You need to do a lot of other things other than the business logic, like service to service communication, retry logic etc. 
- So service mesh built on a sidecar design pattern, as in this the microservice just does the business logic and all the other things are handled by an auxilary component.
- Istio is an example for Service mesh 
- Istio internally creates a control plane which handles configuration discovery and certificates, it's called Istiod 
- Each microservice in each node would have a Envoy proxy, which is a "side-car" which would manage all the traffic and letting the microservice do it's stuff without bothering with the service management 

