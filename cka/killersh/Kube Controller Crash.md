---
date: 2025-09-30
tags:
  - ust
  - devops
  - kubernetes
  - cka
---
- The controller is crashed and we have to fix it. 
- We can go the usual root to check the logs in the var directory, the jounalctl or the syslog, or check the crictl 
- This particular example worked with just the var logs 

- We can see the `kuber-controller-manager` _Pod_ is crashing

```bash
kubectl -n kube-system get pod
```

- We should check the logs

```bash
kubectl -n kube-system logs kube-controller-manager-controlplane
```

- It shows us the error

```bash
Error: unknown flag: --project-sidecar-insertion
```

- We can also check the `/var/log/pods/kube-system_kube-controller-manager-controlplane_*/kube-controller-manager/*.log` and it will also show that there is an unknown flag
- To fix we remove the unknown argument in `/etc/kubernetes/manifests/kube-controller-manager.yaml` 
- We can wait some time the _Pod_ should start again, or we force restart via kubelet by moving the manifest out of the manifest directory

```bash
cd /etc/kubernetes/manifests
mv kube-controller-manager.yaml ..
sleep 5
mv ../kube-controller-manager.yaml .
```






