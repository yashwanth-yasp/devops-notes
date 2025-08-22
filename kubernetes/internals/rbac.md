---
date: 2025-08-21
tags:
  - ust
  - devops
  - kubernetes
---

# RBAC

- Role based access control 
- subject - verb - object (rbac is kinda like english sentences)
- RBAC creates roles 
  - roles are actions 
  - roles are namespaced objects 
  - roles are giving some permission, we don't know to who - kinda like discord roles 
- the person who gets these roles (subject) can be done to 
  - user
  - group 
  - service-account 
    - service accounts are made to give permission to microservices 
  - you bind the subject and the role using role binding

- ClusterRole 
  - Not part of a namespace 
  - permission will be avaiable in all places
  - Cluster Role