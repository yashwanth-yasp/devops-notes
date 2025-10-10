---
date: 2025-09-29
tags:
  - kubernetes
  - devops
  - ust
  - cka
---

The idea here is to misconfigure the Apiserver in different ways, then check possible log locations for errors.

You should be very comfortable with situations where the Apiserver is not coming back up.

Configure the Apiserver manifest with a new argument `--this-is-very-wrong` .

Check if the _Pod_ comes back up and what logs this causes.

Fix the Apiserver again.

Log locations to check:
- `/var/log/pods`
- `/var/log/containers`
- `crictl ps` + `crictl logs`
- `docker ps` + `docker logs` (in case when Docker is used)
- kubelet logs: `/var/log/syslog` or `journalctl`


- Breaking api-server by adding a new unknown flag called `this-is-very-wrong` in the manifest file

```bash
# always make a backup !
cp /etc/kubernetes/manifests/kube-apiserver.yaml ~/kube-apiserver.yaml.ori

# make the change
vim /etc/kubernetes/manifests/kube-apiserver.yaml

# wait till container restarts
watch crictl ps

# check for apiserver pod
k -n kube-system get pod
```

- Api server will go down and you will not be able to run kubectl get commands 
- To verify this we can check the pod logs 

```bash
# check pod logs 
cat /var/log/pods/kube-system_kube-apiserver-controlplane_a3a455d471f833137588e71658e739da/kube-apiserver/X.log > 2022-01-26T10:41:12.401641185Z stderr F Error: unknown flag: --this-is-very-wrong
```

- Now we copy back our backup and check if it comes back up 

```bash
# smart people use a backup
cp ~/kube-apiserver.yaml.ori /etc/kubernetes/manifests/kube-apiserver.yaml
```

- We can also add the `this-is-very-wrong` flag to an already existing flag and the api-server would crash again
- Instead of looking at the `/var/log/pods/kube-system_kube-apiserver` , you can also checkout the exited crio container's logs 

```bash
# 1) if we would check the /var directory
cat /var/log/pods/kube-system_kube-apiserver-controlplane_e24b3821e9bdc47a91209bfb04056993/kube-apiserver/X.log
> Err: connection error: desc = "transport: Error while dialing dial tcp: address this-is-very-wrong: missing port in address". Reconnecting...

# 2) but here we want to find other ways, so we check the container logs
crictl ps # maybe run a few times, because the apiserver container get's restarted
crictl logs f669a6f3afda2
> Error while dialing dial tcp: address this-is-very-wrong: missing port in address. Reconnecting...

# 3) what about syslogs
journalctl | grep apiserver # nothing specific
cat /var/log/syslog | grep apiserver # nothing specific
```


- Now we can modify the syntax of the api-server yaml itself and check if that changes anything, and if it crashes, fix it by looking at the logs
- Now we will not be able to see the api-server even in logs and also in crictl, it will not come back 

```bash
# seems like the kubelet can't even create the apiserver pod/container
/var/log/pods # nothing
crictl logs # nothing

# syslogs:
tail -f /var/log/syslog | grep apiserver
> Could not process manifest file err="/etc/kubernetes/manifests/kube-apiserver.yaml: couldn't parse as pod(yaml: mapping values are not allowed in this context), please check config file"

# or:
journalctl | grep apiserver
> Could not process manifest file" err="/etc/kubernetes/manifests/kube-apiserver.yaml: couldn't parse as pod(yaml: mapping values are not allowed in this context), please check config file
```

- This time the logs were not there in the var as, kubelet failed in the process of creating the container itself, so the logs never came in the crictl and /var/log/pods

- The API server on control-plane nodes is a **static pod**
	- kubelet on that node watches `/etc/kubernetes/manifests/kube-apiserver.yaml` (or wherever your manifests live).
	- For each valid manifest, kubelet creates a **mirror pod** entry in the API and then asks containerd to run it.
	- Logs for that running container go to containerd → `/var/log/pods/...` and `crictl logs` works.
- What happens when you break the YAML
	- kubelet continuously re-reads the manifest file.
	- If the file can’t be parsed (bad YAML, missing apiVersion, etc.), kubelet **deletes the static pod** because it can’t reconcile it anymore.
	- As soon as kubelet deletes the static pod, it also removes the mirror-pod object from the API.
	- containerd kills the old container and removes its metadata.
	- kubelet cleans up the per-pod log directory under `/var/log/pods/<ns>_<pod>` after a short grace period.

Because kubelet never successfully parsed the new manifest, no new container was started. The only component that “knows” about the error is **kubelet itself**, so the error goes to `journalctl -u kubelet` (or syslog).  
The apiserver binary never even starts again, so there’s nothing to log from its side.

![[Pasted image 20250929115832.png]]

