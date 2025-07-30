---
date: 2025-07-29
tags:
  - cloud
  - ust
  - devops
  - aws
  - networking
---
# AWS 

- Aws (Amazon web service) is a cloud computing platform that provides over 200 cloud services.
- Key Concepts
	- Region: A geographical area containing multiple availability zones
	- Availability zones(AZ): Isolated data centres in a region 
	- Edge locations: Content delivery network endpoints for faster content delivery 

## AWS Networking Stack 

- Core Networking Componnents
	- Virtual Private Cloud (VPC): Your isolated network environment 
	- Subnets: Local subdivisions of the VPC 
	- Internet Gateway (IGW): Provides internet access to public subnets 
	- NAT Gateway/Instance: Enables outbound internet access for private subnets
	- Route tables: Define traffic routing rules 
	- Security Groups: Virtual firewalls for EC2 instances
	- Network ACLs: Subnet level firewalls 
	- VPC Endpoints: Private connections to AWS services

![[Pasted image 20250729153359.png]]

## Virtual Private Cloud 

- A VPC is your isolated virtual network in AWS 
- It acts as a private data center for the user where they can use AWS resources 
- Characteristics 
	- IP Address Range: An IP Address range is allocated for a VPC in CIDR notation 
	- Isolation: Completly isolated from other VPC's by default 
	- Regional: Spans over all availabality zones in a region but doesn't connect to a device in a different region 
	- Customizable: Full control over the network configuration 
- VPC Components 
	- CIDR Blocks
		- Primary CIDR: The main IP address range (e.g., 10.0.0.0/16)
		- Secondary CIDR: Additional IP ranges can be added later
		- Size Range: /16 to /28 (65,536 to 16 IP addresses)
	- DHCP Option sets
		- You can use dhcp option sets to set up dns servers that the instances in your vpc will use for domain resolution 
		- You can specify the IP addresses of NTP servers to ensure all instances in your VPC have synchronized time, which is critical for many applications and logging.

![[Pasted image 20250729155750.png]]

### AWS CLI 

```bash
# Create VPC
aws ec2 create-vpc \
    --cidr-block 10.0.0.0/16 \
    --tag-specifications 'ResourceType=vpc,Tags=[{Key=Name,Value=MyCompanyVPC}]'

# Enable DNS hostnames
aws ec2 modify-vpc-attribute \
    --vpc-id vpc-12345678 \
    --enable-dns-hostnames
```

- CloudFormation Template 

```yaml
AWSTemplateFormatVersion: '2010-09-09'
Resources:
  MyVPC:
    Type: AWS::EC2::VPC
    Properties:
      CidrBlock: 10.0.0.0/16
      EnableDnsHostnames: true
      EnableDnsSupport: true
      Tags:
        - Key: Name
          Value: MyCompanyVPC
```

## Subnets 

- Subnets are subdivisions of your VPC that allow you to organize resources and control network traffic. They exist within a single Availability Zone.
- Types of Subnets 
	- Public Subnets 
		- IGW: Direct access to/from internet via Internet Gateway
		- Use cases: Web servers, load balancers, bastion hosts
		- Route Table: Contains route to the IGW (0.0.0.0/0 -> igw-xxx)
	- Private Subnet 
		- No Direct Internet Access
		- Outbound Internet 
			-  When an instance in the private subnet needs to access the internet (e.g., fetching a package from GitHub), it sends the request.
			- The private subnet's route table directs this traffic to the NAT Gateway.
			- The NAT Gateway receives the traffic, performs Network Address Translation, replacing the private IP address of the instance with its own public Elastic IP address.
			- The NAT Gateway then sends this traffic through the public subnet's route table to the Internet Gateway, which forwards it to the internet.
			- When the response comes back from the internet, it's addressed to the NAT Gateway's public IP.
			- The NAT Gateway translates the destination IP address back to the private IP of the original instance and forwards the response to it.
		- Use Cases: Application servers, databases, internal services
	- Database Subnets 
		- Highly Isolated: Often in multiple AZs for high availability
		- No Internet Accesss: Not even NAT Gateway route 
		- Use Cases: RDS databases, ElastiCache clusters

```txt
IP Address Allocation

VPC: 10.0.0.0/16 (65,536 addresses)

Public Subnets:
├── Public-A: 10.0.1.0/24 (254 usable addresses)
├── Public-B: 10.0.2.0/24 (254 usable addresses)

Private Subnets:
├── Private-A: 10.0.10.0/24 (254 usable addresses)
├── Private-B: 10.0.11.0/24 (254 usable addresses)

Database Subnets:
├── DB-A: 10.0.20.0/24 (254 usable addresses)
└── DB-B: 10.0.21.0/24 (254 usable addresses)
```

### Route Tables 

- Public Subnet Route Table

```txt
Destination    Target
10.0.0.0/16   Local
0.0.0.0/0     igw-12345678
```

- Private Subnet Route Table

```txt
Destination    Target
10.0.0.0/16   Local
0.0.0.0/0     nat-12345678
```

## Bastion Hosts

- A bastion host is a hardened server that provides secure access to private resources in your VPC. It acts as a "jump box" or gateway for administrative access.
- Benfits 
	- Single point of entry for administrative access
	- All administrative access can be logged and monitored
	- Centralized access control and authentication
	- Helps meet audit and compliance requirements

![[Pasted image 20250729173044.png]]

- Implemenation Options 
	- Using EC2
		- Need to match AMI and instance types according to aws requirements 
		- Uses ssh key for authentication 
		- Security Group must have Restrictive Inbound rules
	- Using AWS System Manager Session Manager 
		- No open inbound ports required
		- No SSH keys to manage
		- Built-in logging and auditing
		- Works through AWS console or CLI

- Bastian Host best practices
	- Security Hardening 
		- Minimize Attack Surface 
		- SSH Hardening 
		- Logging and Monitoring 
	- Manage Access Control 

# Best Practices 

![[Pasted image 20250729173905.png]]

![[Pasted image 20250729173949.png]]

![[Pasted image 20250729174014.png]]

![[Pasted image 20250729174037.png]]

# Trouble Shooting 

![[Pasted image 20250729174109.png]]

![[Pasted image 20250729174122.png]]

![[Pasted image 20250729174142.png]]

![[Pasted image 20250729174154.png]]

![[Pasted image 20250729174209.png]]

![[Pasted image 20250729174221.png]]

