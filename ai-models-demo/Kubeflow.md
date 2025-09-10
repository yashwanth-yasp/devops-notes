---
date: 2025-09-09
Speaker: ydg
tags:
  - ust
  - ai
  - kubernetes
  - kubeflow
---
Kubeflow is an open-source ML platform that **brings reproducible, portable, Kubernetes-native ML workflows** to teams, it’s modular (use only the pieces you need) and scales with Kubernetes for training, hyperparameter tuning, pipelines, and model serving

# What Kubeflow _has_

- **Kubeflow Pipelines (KFP)** — build, run, track, and version containerized ML workflows (visual UI + SDK). Ideal for experiment reproducibility and pipeline orchestration. [Kubeflow](https://www.kubeflow.org/docs/components/pipelines/overview/?utm_source=chatgpt.com)
- **KServe (model serving)** — formerly KFServing, provides autoscaling, multi-framework support and production inference features. [Kubeflow+1](https://www.kubeflow.org/docs/components/kserve/introduction/?utm_source=chatgpt.com)
- **Katib** — automated hyperparameter tuning. [Kubeflow](https://www.kubeflow.org/docs/started/architecture/?utm_source=chatgpt.com)
- **Notebooks** — Jupyter integration on Kubernetes (dev → prod path). [Kubeflow](https://www.kubeflow.org/docs/started/architecture/?utm_source=chatgpt.com)
- **Training operators** (TFJob, PyTorchJob, MPIJob) — native CRDs to launch distributed jobs. [Kubeflow](https://www.kubeflow.org/docs/started/architecture/?utm_source=chatgpt.com)
- **Metadata & experiment tracking** — auditability, artifact/version tracking for reproducibility. [Kubeflow](https://www.kubeflow.org/docs/components/pipelines/overview/?utm_source=chatgpt.com)

![[Pasted image 20250910103934.png]]
### Flow:

1. **User submits ML workflow** (via UI or SDK).
2. **Kubeflow components create CRDs**:
    - Pipelines → DAG of container steps → each step = Pod.
    - Training → `TFJob` CRD → Kubernetes spawns worker/ps pods.
    - Serving → `InferenceService` CRD → KServe manages deployment.
3. **Kubernetes handles scheduling and scaling**:
    - Places pods on available nodes (CPU/GPU scheduling).
    - Manages networking, service discovery, secrets, storage.
4. **Kubeflow controllers monitor CRDs**:
    - E.g., TFJob controller ensures all training pods run & restart if fail.
    - Katib controller launches multiple jobs in parallel for tuning.
    - KServe controller integrates with Knative/Istio for routing + autoscaling.

# When & why you’d pick Kubeflow

Use Kubeflow when:

- You already **use Kubernetes** and want Kubernetes-native reproducible ML workflows, autoscaling and GPU orchestration. [Portworx](https://portworx.com/knowledge-hub/what-is-kubeflow-an-introduction/?utm_source=chatgpt.com)
- You need an **integrated platform** covering pipelines, tuning, serving, notebooks and distributed training in one composable ecosystem. [Kubeflow](https://www.kubeflow.org/docs/started/architecture/?utm_source=chatgpt.com)
- You want **portability** across clouds and on-prem without vendor lock-in. [Kubeflow](https://www.kubeflow.org/docs/started/introduction/?utm_source=chatgpt.com)

Avoid Kubeflow when:

- Your team does **not** have Kubernetes experience and you need a managed, low-ops solution quickly. Operating Kubeflow can be nontrivial and adds infra overhead. [Medium](https://jlgjosue.medium.com/do-not-use-kubeflow-c8a38a5307a2?utm_source=chatgpt.com)[G2](https://www.g2.com/products/kubeflow/reviews?qs=pros-and-cons&utm_source=chatgpt.com)
- You need **tight single-vendor integrations** (e.g., deep AWS or Google managed services) and want the cloud provider to handle the plumbing and billing/monitoring for you. [StackShare](https://stackshare.io/stackups/amazon-sagemaker-vs-kubeflow?utm_source=chatgpt.com)

# Competitors & concise comparison
## Kubeflow vs MLflow

- **MLflow** focuses on experiment tracking, model registry and simple pipelines, it’s lightweight and framework-agnostic.
- **Kubeflow** is a full platform for orchestration and serving on Kubernetes.  
    **Choose MLflow** if you want minimal ops, simple tracking, and you don’t need Kubernetes orchestration, **Choose Kubeflow** if you need end-to-end pipeline orchestration and scale. [ZenML](https://www.zenml.io/blog/kubeflow-vs-mlflow?utm_source=chatgpt.com)[Kubeflow](https://www.kubeflow.org/docs/components/pipelines/overview/?utm_source=chatgpt.com)

## Kubeflow vs TFX (TensorFlow Extended)

- **TFX** is opinionated and rich for TensorFlow production pipelines and integrates tightly with TF model analysis and serving.
- **Kubeflow Pipelines** is more general and can orchestrate arbitrary containers and frameworks.  
    **Choose TFX** when you are heavily TensorFlow-centric and want Google-style production best practices, **Choose Kubeflow** for framework flexibility and Kubernetes portability. [Google Cloud](https://cloud.google.com/architecture/architecture-for-mlops-using-tfx-kubeflow-pipelines-and-cloud-build?utm_source=chatgpt.com)[Kubeflow](https://www.kubeflow.org/docs/components/pipelines/overview/?utm_source=chatgpt.com)

## Kubeflow vs Managed Cloud Services (SageMaker / Vertex AI)

- **SageMaker / Vertex AI** are managed platforms with tight cloud vendor integration, easier onboarding, and pay-as-you-go managed infra.
- **Kubeflow** avoids vendor lock-in and offers more control but requires self-management.  
    **Choose managed services** when you want low ops and tight cloud feature integration; **Choose Kubeflow** if you need portability, open-source flexibility, or multi-cloud/on-prem deployments. [StackShare](https://stackshare.io/stackups/amazon-sagemaker-vs-kubeflow?utm_source=chatgpt.com)[Kubeflow](https://www.kubeflow.org/docs/started/introduction/?utm_source=chatgpt.com)

