

# Kubernetes 

- **Describe the main components of the Kubernetes control plane and the worker nodes. Why is etcd so critical?**
  - Control Plane (The "Brain"): This is the set of components that manages the overall state of the cluster.
    - kube-apiserver: The frontend for the control plane. It exposes the Kubernetes API and is the only component that talks directly to etcd. All interactions (from kubectl, controllers, etc.) go through the API server.
    - etcd: A consistent and highly-available key-value store. It is the single source of truth for the entire cluster. It stores the desired state and the actual state of all Kubernetes objects (Pods, Services, Deployments, etc.).
    - kube-scheduler: Watches the API server for newly created Pods that have no node assigned. It then runs its filtering and scoring algorithm to select the best node for that Pod to run on.
    - kube-controller-manager: Runs all the built-in controllers. Each controller is a reconciliation loop that watches for changes and tries to drive the cluster's actual state toward the desired state (e.g., the deployment controller ensures the correct number of replicas are running).
  - Worker Nodes (The "Muscle"): These are the machines where your applications actually run.
    - kubelet: The primary agent that runs on each worker node. It communicates with the API server and is responsible for ensuring that the containers described in PodSpecs are running and healthy on its node.
    - kube-proxy: A network proxy that runs on each node. It maintains the network rules that enable Kubernetes networking concepts, particularly routing traffic to the correct Pods for a Service.
    - Container Runtime: The software responsible for running containers (e.g., containerd, CRI-O).
  - Why etcd is so critical: If you lose the data in etcd, you lose the state of your entire cluster—all Deployments, Pods, Services, and configurations are gone. It's the cluster's memory. This is why it must be run in a highly-available, multi-node configuration with regular backups.


- **How is api-server searching so fast in etcd** (it has cache and the underlying database is B+ tree database which has O(logn) search time)

- **How does the even driven in etcd actually work?**
  - They use etcd’s watch mechanism.
  - etcd is the one that actually streams events.
    - etcd has a watch API (long-lived gRPC stream).
    - The API server registers a watch with etcd for certain key prefixes (e.g. /registry/pods/).
    - When a Pod is created/updated/deleted, etcd pushes that event down the stream to the API server.
    - API server then updates its in-memory cache and re-broadcasts the event to anyone who’s watching it (kubelets, controllers, kubectl).
    - So kube-proxy, kubelet, or your kubectl get --watch are not watching etcd directly, they’re watching the API server.
    - The API server acts as a fan-out hub between etcd and all the clients.


- **What is the core principle that drives Kubernetes? Explain the concept of a "reconciliation loop."**
  - The core principle is declarative state management. You declare the desired state of your system in a manifest file (YAML), and Kubernetes works tirelessly to make the actual state of the system match.
  - This is achieved through reconciliation loops (also called control loops). A controller (like the deployment controller) continuously performs these steps:
    - Observe: It gets the desired state from the API server (e.g., "I should have 3 replicas of the Nginx Pod").
    - Compare: It gets the current, actual state (e.g., "I can only find 2 running Nginx Pods").
    - Act: It calculates the difference and takes action to reconcile it. In this case, it would make an API call to create one new Nginx Pod.
  - This loop runs constantly, making Kubernetes a self-healing system. If a node dies and a Pod disappears, the controller will observe the discrepancy and create a new Pod on a healthy node to bring the system back to the desired state.



