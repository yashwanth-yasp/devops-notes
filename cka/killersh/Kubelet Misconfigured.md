---
date: 2025-09-30
tags:
  - ust
  - devops
  - kubernetes
  - cka
---
- The status is showing a failure 

```bash
ssh node01
    service kubelet status
```

- We should check the logs

```bash
grep kubelet /var/log/syslog
```

- It shows us the error

```bash
Feb 21 16:50:41 node01 kubelet[9516]: E0221 16:50:41.994746    9516 run.go:74] "command failed"
err="failed to parse kubelet flag: unknown flag: --improve-speed"
```

- To fix we remove the unknown flag in `/var/lib/kubelet/kubeadm-flags.env`

```bash
KUBELET_KUBEADM_ARGS="--container-runtime-endpoint=unix:///var/run/containerd/containerd.sock --pod-infra-container-image=registry.k8s.io/pause:3.9"
```

- And the status should be good again

```bash
service kubelet restart

service kubelet status
```

- Me being the dumbass I am directly went to the main conf file fo the kubelet service in `/usr/lib/systemd/system/kubelet.service.d/10-kubeadm.conf`
- And saw two `ExecStart=` commands, one empty and thought this must be the error and deleted it. 
- But that was not the error 
- The **main unit file** `/usr/lib/systemd/system/kubelet.service` already defines an `ExecStart=`.
- Your drop-in `10-kubeadm.conf` also defines another `ExecStart=`.
- Systemd doesn’t merge them — it thinks you’re trying to run _both_.
- That **first blank `ExecStart=` line** is very important — it tells systemd “reset any previous ExecStart before applying this one.”
- Then I looked at the logs and saw that there was a random flag in the env file and removed it and it started working.



