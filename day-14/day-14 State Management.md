
- State Management 
  - State management refers to the handling of data that changes over time within an application. It encompasses how data flows between components, how it's stored, updated, and synchronized across different parts of your system.

- Types of Locking 
  - Optimistic = assume no conflict, check at the end.
  - Pessimistic = block others immediately, safe but slower.
  - Distributed = extend locking across multiple servers/nodes.

- Remote management of the terraform state file is done through the use of s3 and dynamodb in aws
  - The state file is stored in a s3 bucket
  - The dynamodb is set up to store the lock for the file 
  - If someone is doing terraform apply to the state file, dynamo db puts a lock and denies any other try to do the same by any other developer 
  - It kind of works like a semaphore


