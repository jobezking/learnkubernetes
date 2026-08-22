# Docker Deployment 
docker run -d --name=redis redis                  # in memory data store db
docker run -d --name=db postgres:9.4              # backend db
docker run -d --name=vote -p 5000:80 voting-app --link redis:redis   # Python voting app
docker run -d --name=result -p 5001:80 result-app --link db:db # node.js app to build webpage to show results
docker run -d --name=worker worker --link db:db --link redis:redis     # .NET app background service

#Kubernetes deployment process
1. Deploy containers
2. Enable connectivity
3. Enable external access

Steps
1. Deploy pods (or replicasets or deployments)
2. Enable connectivity between services. Need to know which applications are needed by what services
3a. Create redis service named redis so it can be accessed by voting and worker apps (ClusterIP)
3b. Create db service named db so it can be accessed by result and worker apps (ClusterIP). The db pod will need username and password
3c. External access services for voting and result apps (Nodeport)
5 total ports. 4 services: one for redis, one for Postgres (internal, ClusterIP) plus external for result and voting (Nodeport). No worker service

Containers:
kodekloud/examplevotingapp_vote:v1
kodekloud/examplevotingapp_result:v1
kodekloud/examplevotingapp_worker:v1
redis
postgresql