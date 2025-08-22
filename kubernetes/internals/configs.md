---
date: 2025-08-21
tags:
  - ust
  - devops
  - kubernetes
---

- configmap
  - A Kubernetes object that holds non-sensitive configuration data. 
  - configmap is visible 
  - you make this when it's okay for that object to be visible 
- secret 
  - A Kubernetes object for sensitive data
  - secret is not visible only if you hit etcd 
- both are clearly available inside the container in plain-text not encoded 
- if it's available then how are secrets "secrets", cause it can be userd for RBAC
- Secrets can be injected into the container in two ways
	- as a environment variable
	- as a volume 

- `kubectl create secret generic mysecret --from-file=user.txt --from-file=pass.txt` in this command, the key for the secret would be the string "user.txt", so it is preferred to just make a file without the .txt for ease 
