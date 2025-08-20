
- `kubectl create rs ydgreplica --image=nginx --replicas=3`
- usually the kubectl apply is used as there is traceability with the yaml file 
- When a replca set is created, the path is similar to how a pod is created but here, when the command is written to etcd, the replication controller is up and writes the pods to etcd and then the scheduler comes in, finds nodes fit for the pods and api-server contacts kubelet and the replication controller is watching this and updates replicaset to running after all pods show running 

 