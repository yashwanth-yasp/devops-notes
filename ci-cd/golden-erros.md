
# The Github Actions - Kubernetes deadlock 

- I had four github actions, three CI for each microservices and one CD for deployment. 
- My app was not showing the changes I made and pushed, but everything was passing 
- The issue was the lack of the dependency between the Deployment action and the integration action, which caused the deployment to run first which was before the image was pushed so it never showed the updates 

- The other part of the problem is that kubernetes sometimes doesn't pull the image from the docker hub even if the Image pull policy is always, so the solution is to add github sha id in the image tag and use that exact image tag in the kubernetes image update in the deployment action file 