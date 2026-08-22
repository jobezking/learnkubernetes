Go to GKE > Create cluster > rename it > Create with defaults > Connect
git clone https://github.com/jobezking/learnkubernetes and cd to 
https://github.com/jobezking/learnkubernetes/tree/main/a_udemy/course1/a_microservices_example/yaml/deployments
and kubectl apply -f .
repeat for 
https://github.com/jobezking/learnkubernetes/tree/main/a_udemy/course1/a_microservices_example/yaml/services

monitor with kubectl get all until everything comes up
then go to Gateways, Services & Ingress in console and choose Services tab. The External load balancers will be listed
with URLs to the voting and results pages