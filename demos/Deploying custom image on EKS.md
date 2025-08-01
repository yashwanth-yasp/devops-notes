---
date: 2025-08-01
tags:
  - ust
  - devops
  - eks
  - aws
  - kubernetes
---

# Creating  a Cluster

- First creating a new ec2 instance and giving it an IAM role that has permissions to access eks 
- Create a  new role with the `AmazonEKSClusterPolicy` and `AmazonEKSVPCResourceController` policies
- Once that's done, the ec2 instance has access to the EKS and it can create a cluster now 

```bash
eksctl create cluster --name=eksydg --region=us-east-1 --zones=us-east-1a,us-east-1b --without-nodegroup
```

![[Screenshots/Pasted image 20250801142451.png]]

![[Pasted image 20250801142341.png]]

![[Pasted image 20250801142318.png]]

![[Pasted image 20250801153615.png]]

# Creating Node Groups 

```bash
eksctl create nodegroup \
  --cluster eksydg \
  --region us-east-1 \
  --name workers \
  --node-type t3.micro \
  --nodes 2 \
  --nodes-min 1 \
  --nodes-max 3 \
  --managed
```

![[Pasted image 20250801150414.png]]

![[Pasted image 20250801150434.png]]

![[Pasted image 20250801150651.png]]

- Scaling nodegroups 

```bash
eksctl create nodegroup \
  --cluster eksydg \
  --region us-east-1 \
  --name workers \
  --node-type t3.micro \
  --nodes 2 \
  --nodes-min 1 \
  --nodes-max 3 \
  --managed
```

![[Pasted image 20250801151443.png]]

# Deleting a nodegroup

![[Pasted image 20250801152539.png]]
# Deleting Cluster 

![[Pasted image 20250801153522.png]]

![[Pasted image 20250801153726.png]]

# Permissions given  to the IAM role 

![[Pasted image 20250801153847.png]]

![[Pasted image 20250801153907.png]]

# Stopping the Instance 

![[Pasted image 20250801154027.png]]

# Issues I faced 

- The IAM role I created didn't have permission to create VPC and store errors in CloudFormation 
	- fixed it by giving those permissions 
- The create cluster failed again cause the max number of vpcs in nv region already reached, which was 5, so I deleted my vpc 
- The create cluster failed again cause IAM role access was not in the role
	- resloved it by giving IAM Access to the role 

- Used eksctl to add the context of the cluster to kubectl config 

```bash
eksctl utils write-kubeconfig --cluster=eksydg --region=us-east-1
```



![[Pasted image 20250801153652.png]]

