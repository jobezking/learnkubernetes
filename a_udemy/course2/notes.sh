kubectl get pods -n kube-system  # shows kubernetes system pods
kubectl run nginx --image=nginx
kubectl scale replicaset myapp-replicaset --replicas=5
kubectl scale rs myapp-replicaset --replicas=5
kubectl scale --replicas=5 -f replicaset-definition.yml
kubectl delete rs myapp-replicaset
kubectl replace -f replicaset-definition.yml
#Deployments automatically create ReplicaSets with the name of the deployment and create pods including the name of the deployment

Reference (Bookmark this page for exam. It will be very handy):

https://kubernetes.io/docs/reference/kubectl/conventions/

Create an NGINX Pod

kubectl run nginx --image=nginx

Generate POD Manifest YAML file (-o yaml). Don't create it(--dry-run)

kubectl run nginx --image=nginx --dry-run=client -o yaml

Create a deployment

kubectl create deployment --image=nginx nginx

Generate Deployment YAML file (-o yaml). Don't create it(--dry-run)

kubectl create deployment --image=nginx nginx --dry-run=client -o yaml

Generate Deployment YAML file (-o yaml). Don’t create it(–dry-run) and save it to a file.

kubectl create deployment --image=nginx nginx --dry-run=client -o yaml > nginx-deployment.yaml

Make necessary changes to the file (for example, adding more replicas) and then create the deployment.

kubectl create -f nginx-deployment.yaml

OR

In k8s version 1.19+, we can specify the --replicas option to create a deployment with 4 replicas.

kubectl create deployment --image=nginx nginx --replicas=4 --dry-run=client -o yaml > nginx-deployment.yaml
kubectl create deployment httpd-frontend --image=httpd:2.4-alpine --replicas=4
kubectl create deployment httpd-frontend --image=httpd:2.4-alpine --replicas=4 --dry-run=client -o yaml > httpd-frontend-deployment.yaml