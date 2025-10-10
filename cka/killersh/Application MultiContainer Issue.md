---
date: 2025-09-30
tags:
  - ust
  - devops
  - kubernetes
  - cka
---
- One of the containers in the deployment is not coming up 
- the task it to collect the logs of all containers in the deployment and store in a simple file called `logs.log`
- We can either use a bash script or a single command for this 
- Bash Script

```bash
#!/bin/bash

: > logs.log # this clears the logs before this execution

for pod in $(kubectl get pods -l app=collect-data -o jsonpath='{.items[*].metadata.name}' -n management); do
  echo $pod
  for container in $(kubectl get pod $pod -o jsonpath='{.spec.containers[*].name}' -n management); do
    echo $container
    echo "=== Logs from $pod / $container ===" >>logs.log
    kubectl logs $pod -c $container -n management >>logs.log
  done
done
```

- or you can use a simple kubectl command like this

```bash
kubectl -n management logs --all-containers deploy/collect-data > /root/logs.log
```

- You can fix this by removing one of the containers in the deployment
- There is one more way where you edit the application itself to listen on a different port but as we are using pre-built images, we won't be able to do that 


