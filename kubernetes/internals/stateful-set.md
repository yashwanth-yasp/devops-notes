---
date: 2025-08-21
tags:
  - ust
  - devops
  - kubernetes
---

# Stateful Sets

- StatefulSets are a special type of kubernetes resource used when you need to manage stateful applications — apps that require stable, unique network identities and persistent storage across pod restarts.
- Stateful sets are similar to sql architecture, it has a certain number of copies of the database, that is why it's called stateful-set, basically a set of stateful instances 
- it has a clusterIP associated to it which always points to the primary database, if it goes down the secondary is made the primary 
- the databases 

