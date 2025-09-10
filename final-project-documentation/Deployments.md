---
date: 2025-09-06
tags:
  - ust
  - devops
  - kubernetes
---

# Kubernetes Manifest Documentation for Find-Your-Bias

This document provides a comprehensive overview of all the Kubernetes manifest files used in the `find-your-bias-org` project. It is intended to help developers understand the architecture and deployment strategy of the application on Kubernetes.

## Core Infrastructure (`infra`)

The `infra` directory contains the Kubernetes manifests for the core, stateful components of the application: the PostgreSQL database and the Redis cache.

### Database (PostgreSQL)

The database is used to persist the votes. It is configured as a stateful application to ensure data is not lost if the pod restarts.

-   **`db-statefulset.yaml`**:
    -   **Kind**: `StatefulSet`
    -   **Purpose**: Manages the deployment of the PostgreSQL database pod. A `StatefulSet` is used because the database requires stable, unique network identifiers and persistent storage that survives pod rescheduling.

-   **`db-service.yaml`**:
    -   **Kind**: `Service`
    -   **Purpose**: Provides a stable network endpoint (a DNS name: `db`) for other services within the cluster to connect to the PostgreSQL database. This is a "headless" service, which is typical for StatefulSets.

-   **`db-pv.yaml`**:
    -   **Kind**: `PersistentVolume` (PV)
    -   **Purpose**: Provisions a cluster-wide storage volume on the host machine (`/mnt/data/db`) to be used by the database. This separates the storage resource from the pod lifecycle.

-   **`db-pvc.yaml`**:
    -   **Kind**: `PersistentVolumeClaim` (PVC)
    -   **Purpose**: A request for storage made by the `StatefulSet`. It binds to the `PersistentVolume` defined in `db-pv.yaml`, allowing the database pod to mount and use it.

-   **`db-network-policy.yaml`**:
    -   **Kind**: `NetworkPolicy`
    -   **Purpose**: A security rule that controls traffic to and from the database pod. It only allows incoming connections from the `worker-service` and `result-service`, enforcing the principle of least privilege.

### Cache (Redis)

Redis is used as a message queue. The `vote-service` pushes votes into a Redis list, and the `worker-service` pulls votes from it for processing.

-   **`redis-statefulset.yaml`**:
    -   **Kind**: `StatefulSet`
    -   **Purpose**: Manages the deployment of the Redis pod. Like the database, it's deployed as a `StatefulSet` to ensure stable network identity and storage.

-   **`redis-service.yaml`**:
    -   **Kind**: `Service`
    -   **Purpose**: Provides a stable network endpoint (DNS name: `redis`) for other services to connect to the Redis cache.

-   **`redis-pv.yaml`**:
    -   **Kind**: `PersistentVolume`
    -   **Purpose**: Provisions a storage volume on the host machine (`/mnt/data/redis`) for Redis data persistence.

-   **`redis-pvc.yaml`**:
    -   **Kind**: `PersistentVolumeClaim`
    -   **Purpose**: Claims the storage defined in `redis-pv.yaml` so the Redis pod can use it.

-   **`redis-network-policy.yaml`**:
    -   **Kind**: `NetworkPolicy`
    -   **Purpose**: A security rule that only allows the `vote-service` and `worker-service` to connect to the Redis pod.

### Ingress

Ingress resources manage external access to the services in the cluster, typically HTTP. They provide routing rules based on hostnames or paths.

-   **`ingress-vote.yaml`**:
    -   **Kind**: `Ingress`
    -   **Purpose**: Exposes the `vote-service` to the outside world, allowing users to access the voting web interface.

-   **`ingress-result.yaml`**:
    -   **Kind**: `Ingress`
    -   **Purpose**: Exposes the `result-service` to the outside world, allowing users to view the voting results.

---

## Microservices

Each microservice has its own set of Kubernetes manifests to define how it is deployed, exposed, and secured.

### `vote-microservice`

-   **`vote-deployment.yaml`**:
    -   **Kind**: `Deployment`
    -   **Purpose**: Manages the deployment of the `vote-service` pods, defining the container image, replicas, and other runtime settings.
-   **`vote-service.yaml`**:
    -   **Kind**: `Service`
    -   **Purpose**: Exposes the `vote-service` pods at a stable internal DNS name (`vote`) so the Ingress controller can route traffic to it.
-   **`vote-hpa.yaml`**:
    -   **Kind**: `HorizontalPodAutoscaler` (HPA)
    -   **Purpose**: Automatically scales the number of `vote-service` pods up or down based on CPU utilization to handle variable traffic loads.
-   **`vote-network-policy.yaml`**:
    -   **Kind**: `NetworkPolicy`
    -   **Purpose**: Restricts network access. It allows incoming traffic from the Ingress controller and allows the `vote-service` to make outgoing connections to the `redis-service`.

### `result-microservice`

-   **`result-deployment.yaml`**:
    -   **Kind**: `Deployment`
    -   **Purpose**: Manages the deployment of the `result-service` pods.
-   **`result-service.yaml`**:
    -   **Kind**: `Service`
    -   **Purpose**: Exposes the `result-service` internally at the DNS name `result` for the Ingress controller.
-   **`result-hpa.yaml`**:
    -   **Kind**: `HorizontalPodAutoscaler`
    -   **Purpose**: Automatically scales the `result-service` pods based on CPU load.
-   **`result-network-policy.yaml`**:
    -   **Kind**: `NetworkPolicy`
    -   **Purpose**: Allows incoming traffic from the Ingress controller and allows the `result-service` to connect to the `db-service` to fetch results, and to connect to `ai-analyzer` to hit the ai analyzer endpoint.

### `worker-microservice`

-   **`worker-deployment.yaml`**:
    -   **Kind**: `Deployment`
    -   **Purpose**: Manages the deployment of the background `worker-service` pods.
-   **`worker-hpa.yaml`**:
    -   **Kind**: `HorizontalPodAutoscaler`
    -   **Purpose**: Automatically scales the `worker-service` pods based on CPU load.
-   **`worker-network-policy.yaml`**:
    -   **Kind**: `NetworkPolicy`
    -   **Purpose**: Allows the `worker-service` to make outgoing connections to the `redis-service` (to fetch votes), the `db-service` (to store results).
### `ai-analyzer-microservice`

-   **`ai-analyzer-deployment.yaml`**:
    -   **Kind**: `Deployment`
    -   **Purpose**: Manages the deployment of the `ai-analyzer-service` pods.
-   **`ai-analyzer-service.yaml`**:
    -   **Kind**: `Service`
    -   **Purpose**: Exposes the `ai-analyzer-service` internally at the DNS name `ai-analyzer` so the `result-service` can connect to it.
-   **`ai-analyzer-hpa.yaml`**:
    -   **Kind**: `HorizontalPodAutoscaler`
    -   **Purpose**: Automatically scales the `ai-analyzer-service` pods based on CPU load.
-   **`ai-analyzer-network-policy.yaml`**:
    -   **Kind**: `NetworkPolicy`
    -   **Purpose**: Restricts incoming traffic to only allow connections from the `result-service`.


