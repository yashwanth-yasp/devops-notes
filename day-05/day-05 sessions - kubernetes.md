---
date: 2025-07-22
tags:
  - ust
  - devops
  - kubernetes
---

- At its heart, **Kubernetes is an open-source system for automating deployment, scaling, and management of containerized applications.** Think of it as an operating system for your data center, but instead of managing individual applications on a single server, it manages groups of containers across many servers.

# Pods 

- A Pod is the smallest and simplest unit in Kubernetes. It's like a wrapper around one or more containers that need to work closely together.
	- Usually contains a single container but can contain multiple containers and all of the containers in a single pod share the same network and storage
- Why don't we run containers directly and use pods? 
	- Containers in a pod can easily share files and communicate with each other
	- All containers in a pod start and stop together
	- When you scale, you scale entire pods, not individual containers
- Pod Lifecycle 
	- **Pending**: Pod is created but containers aren't running yet
	- **Running**: Pod is running on a node and at least one container is active
	- **Succeeded**: All containers completed successfully
	- **Failed**: At least one container failed
	- **Unknown**: Pod status couldn't be determined
- **Pods are not permanent:** If a pod crashes, it's gone. You need something to restart it.
- **No load balancing:** A single pod can't handle lots of traffic
- **No rolling updates:** You can't easily update a pod without downtime.

# Replica Sets

- A ReplicaSet is like a guardian that watches over your pods. Its job is to make sure you always have the exact number of pods you want running.
- What it does:
	- Monitors your pods constantly
	- If a pod dies, it creates a new one
	- If there are too less, it creates more or if there too much, it removes extras 

```yaml
# replicaset.yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: nginx-replicaset
  labels:
    app: nginx
spec:
  replicas: 3  # We want 3 pods
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.21
        ports:
        - containerPort: 80
```

- Create a verify the replicaset 

```bash
kubectl apply -f replicaset.yaml
kubectl get pods
kubectl get replicaset
```

- Scaling a replica set 

```bash
# Scale up to 5 replicas
kubectl scale replicaset nginx-replicaset --replicas=5

# Scale down to 2 replicas
kubectl scale replicaset nginx-replicaset --replicas=2
```

- The issue with replicasets
	- If you want to update your application, you have to delete the old ReplicaSet and create a new one, causing downtime.
	- You have to manage updates yourself. This is where Deployments become essential.

# Deployments 

- A Deployment is like a smart manager that handles ReplicaSets for you. It's the most commonly used object in Kubernetes because it solves the update problem.
- Features
	- Creates and manages ReplicaSets
	- Handles rolling updates with zero downtime
	- Can rollback to previous versions
	- Provides update history

```yaml
# deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.21
        ports:
        - containerPort: 80
```

```bash
kubectl set image deployment/nginx-deployment nginx=nginx:1.22
kubectl get deployments
kubectl get replicasets
kubectl get pods
```

## Rolling updates

- If we want to update the nginx server version from 1.21 to 1.22

```bash
kubectl set image deployment/nginx-deployment nginx=nginx:1.22
```

```bash
kubectl rollout status deployment/nginx-deployment
```

- So when we rollout a deployment, deployment creates replicasets with the new images while the old images while the old pods are active and terminates them one by one as the new ones get created 
- The old replica sets with 0 pods are preserved for rollback purposes
- Rolling back 

```bash
# See rollout history
kubectl rollout history deployment/nginx-deployment

# Rollback to previous version
kubectl rollout undo deployment/nginx-deployment

# Rollback to specific version
kubectl rollout undo deployment/nginx-deployment --to-revision=1
```

- Real world deployment example 

```yaml
# web-app-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app-deployment
spec:
  replicas: 5
  selector:
    matchLabels:
      app: web-app
  template:
    metadata:
      labels:
        app: web-app
    spec:
      containers:
      - name: web-app
        image: myapp:v1.0
        ports:
        - containerPort: 8080
        env:
        - name: DATABASE_URL
          value: "postgres://db:5432/myapp"
        resources:
          requests:
            memory: "256Mi"
            cpu: "250m"
          limits:
            memory: "512Mi"
            cpu: "500m"
        livenessProbe:
          httpGet:
            path: /health
            port: 8080
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /ready
            port: 8080
          initialDelaySeconds: 5
          periodSeconds: 5
```

# Services: Making Pods Accessible

- Pods have Ips but there is an issue
	- Pods ips change when recreated 
	- we have multiple pods behind a deployment
	- we need a single stable way to access the application 
- A Service is like a permanent address for your pods. 
	- It provides a static ip address that doesn't change
	- load balancing across multiple pods
	- Other apps can find the service by name 
	- It has different ways to expose an application 

## Types of Services 

- Cluster Ip 
	- Makes your service accessible only from within the cluster.

```yaml
# clusterip-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    app: nginx
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
  type: ClusterIP
```

- NodePort
	- Exposes your service on each node's IP address.

```yaml
# nodeport-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-nodeport
spec:
  selector:
    app: nginx
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
    nodePort: 30080  # External port (30000-32767)
  type: NodePort
```

- LoadBalancer
	- Creates an external load balancer (works with cloud providers).

```yaml
# loadbalancer-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-loadbalancer
spec:
  selector:
    app: nginx
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
  type: LoadBalancer
```

- Services provide automatic service discovery. Other pods can reach your service using:

```text
# By service name
http://nginx-service

# By full DNS name
http://nginx-service.default.svc.cluster.local
```

![[Pasted image 20250722173801.png]]

![[Pasted image 20250722173837.png]]

![[Pasted image 20250722173909.png]]

# Common patterns and Best Practices 

- Always Use Deployments (Not ReplicaSets or Pods)
- Set Resource Limits
- Use Health Checks
- Use Meaningful Labels
- Configure Rolling Update Strategy

# Troubleshooting Common Issues

- Pod Issues

```bash
# Check pod status
kubectl get pods

# Get detailed info
kubectl describe pod <pod-name>

# Check pod logs
kubectl logs <pod-name>

# Get shell access to pod
kubectl exec -it <pod-name> -- /bin/bash
```

- Service issues 

```bash
# Check if service is routing to correct pods
kubectl get endpoints <service-name>

# Test service from within cluster
kubectl run test --image=busybox --rm -it --restart=Never -- sh
# Then: wget -q -O- http://<service-name>
```

- Deployment Issues

```bash
# Check deployment status
kubectl rollout status deployment/<deployment-name>

# Check deployment history
kubectl rollout history deployment/<deployment-name>

# Check events
kubectl get events --sort-by=.metadata.creationTimestamp
```

# Commands to initialize a simple single node kubernetes cluster 

```bash
sudo kubeadm init --pod-network-cidr=10.32.0.0/12
kubectl get node
	will show the node in "NotReady" status
kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml
watch -n 1 kubectl get po -n kube-system
	wait until all pods changes to "1/1" or "2/2" "Running"
kubectl describe node | grep -i taint
	copy the taint 
kubectl get node 
	copy the name 
kubectl taint node <node name from above command> node-role.kubernetes.io/control-plane:NoSchedule-
kubectl run nginx --image=nginx
kubectl get po
kubectl get po -o wide
	note the ip 
curl <ip>
	should see nginx output
```

