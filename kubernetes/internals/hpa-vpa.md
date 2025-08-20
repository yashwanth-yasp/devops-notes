
- Horizontal pod autoscaler 
  - If you mention that, kubernetes will automatically scale the pods horizontally when needs 
- Vertical pod autoscaler 
  - If you mention that, kubernetes will automatically scale to previously mentioned resource milestones 
  - If you define 2gb as a limit and define a VPA, say a pod is utilizing is 1.8gb, it will move to a predetermined gb in the VPA, say 3gb 
  - It is recommended to not do this, to just kill the pod
  - If you scale vertically, it always has a limit, it is limited by the machine but horizontal can be done as you can always add more machines  
- Cluster autoscaler 
  - when the node is reaching it's limit, you can invoke the CA to add machines 

- HPA also has a controller which monitors a table for HPA and when the resource column exceeds a given limit, the HPA controller hits the deployment to add more machines, which hits the replica set which hist the api server to add more pods 
- When HPA is created, a metric server is created to monitor the pods 

