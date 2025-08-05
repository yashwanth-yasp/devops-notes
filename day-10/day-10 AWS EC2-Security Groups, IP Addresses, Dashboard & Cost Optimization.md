---
date: 2025-07-31
tags:
  - ust
  - devops
  - aws
  - ec2
---
- Amazon Elastic Compute Cloud (EC2) is a web service that provides resizable compute capacity in the cloud

# Security Groups 

- Security groups act as a virtual firewall for your EC2 instances to control inbound and outbound traffic 
- Key Characteristics 
	- Stateful: If you send a request from your instance, the response traffic is automatically allowed
	- Default Deny: All inbound traffic is denied by default
	- Allow Rules Only: You can only create rules that allow traffic
	- Multiple Groups: An instance can be associated with multiple security groups

