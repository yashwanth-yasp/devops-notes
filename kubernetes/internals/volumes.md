---
date: 2025-08-22
tags:
  - ust
  - devops
  - kubernetes
---
- containers are ephemeral and we need volumes to ensure persistence 
- different types of basic mutli-access storages
	- NFS: you can set up a local multi-access storage in a network
	- EFS
	- EBS
		- you cannot move EBS out of a region where a machine is attached to it but why
	- S3
		- had buckets of data 
		- gradually old and unused data are moved into different storages that gradually increases cost to read and decreases cost to store 


- Ideally the volume should be outside the machine
- All the nodes in the cluster run in a same region 
- we are able to access a ec2 from a different region cause ssh supports it 

- Types of Volumes
	- EmptyDir 
		- This is like tmpfs in docker 
		- The volume is only available until the pod that is attached to it is up 
		- This volume can also be used for communication between two containers of a single pod 
	- HostPath 
		- when you create a hostpath, the volume is created similar to bind mount and binds the volume to the container volume in the pod 
		- but it is not that useful to us cause if the machine fails or the pod is recreated in another machine, will not have access to it 
	- PV 

- PVC
	- what is the data size that we need 
	- what aer the perimission 
	- Storage class 
		- class of storages are made for seperation 
	- whn you create a pvc, iit is notmentioed hwere it be stored?
- PV 
	- The actual volume created after the claim has be made 
	- All the EBS token and details would be stored here 
	- and this is the actual name 
	- the relationship between PVC and PV is one to one 
	- If the PV is more than the PVC requirements then it's okay, but if PV Is lesser than pVC requirements, then it's not good 
	- PV is tightly bound, once you created it with a PVC, you can't change it 

- Storage Object 
	- a pv depnds on a pvc which depends on a pod
	- you can delete something as long as you don't have anything depending on it 
- Reclaim policy 
	- Defines what happens when pv get deleted 
	- delete 
		- delete removes pv object as well as the associated storage asset  
	- recycle 
		- deletes the pv object but the attached storage stays although the data is gone 
	- retain 
		- deletes the pv object but the attached storage stays and the data also stays in the attached storage 
- Reclaim policy of a PV can be edited 
- You can only set a reclaim policy if your attached storage's cloud policy allows it 
- Access modes 
	- ReadWriteOnce 
		- All the containers in pods associated to the PV and are on the machine that the first pod came up on can read and write 
		- all other pods only read 
	- ReadOnlyMany 
		- All the containers in pods associated to the PV can only read
	- ReadWriteMany 
		- All the containers in pods associated to the PV can read and write
	- ReadWriteOncePod
		- Only the first pod that is associated to the PV can read and write, all others only read 
		- This came up in some new version of kubernetes where readwriteonce into readwriteoncepod as before readwriteonce used to mean one pod

- Static provisioning 
	- manually createing a pvc, pv, ebs and attaching them is static provisioning 
- Dynamic provisioning 
	- you create a kuberenets resource of kind StorageClass to provision an EBS volume 
	- Everytime you create a PVC, it will create a PV dynamically 
	- you apply storage class to the whole cluster as it's not a namespaced object 



