kubectl get pods  # shows all pods in the default namespace
kubectl get pods --namespace=kube-system  # shows all pods in the kube-system namespace
kubectl get pods -n kube-system  # shows kubernetes system pods
kubectl get pods --all-namespaces  # shows all pods in all namespaces
kubectl run nginx --image=nginx # create a pod named nginx with the nginx image
kubectl get pod nginx -o yaml > nginx-config.yaml # saves the pod config to a yaml file
kubectl get deployment blue -o yaml > blueconfig.yaml  # saves the deployment config to a yaml file
kubectl create -f pod-definition.yml --namespace=dev # create a pod from a definition file in namespace dev
kubectl run nginx --image=nginx   # create a pod named nginx with the nginx image
kubectl run nginx --image=nginx --namespace=dev   # create a pod named nginx with the nginx image in namespace dev
kubectl get pods --all-namespaces  # shows all pods in all namespaces
kubectl get pods -o wide  # shows all pods with more details
kubectl get pods -o yaml  # shows all pods in yaml format
kubectl get pods -o json  # shows all pods in json format
kubectl get pods -o name  # shows all pods with only their names
kubectl scale replicaset myapp-replicaset --replicas=5
kubectl scale rs myapp-replicaset --replicas=5
kubectl scale --replicas=5 -f replicaset-definition.yml
kubectl delete rs myapp-replicaset
kubectl replace -f replicaset-definition.yml

kubectl api-resources  # shows all api resources available in the cluster
kubectl explain pods  # shows the details of the pod resource
kubectl explain pods.spec  # shows the details of the pod spec
kubectl explain pods.spec.containers  # shows the details of the pod containers
kubectl explain pods --recursive  # shows the details of the pod resource recursively

redis-db-service.dev.svc.cluster.local  # access the redis-db-service in the dev namespace from another pod in the same cluster

kubectl edit [object] [name]  # edit the object in place and also view config file i.e
kubectl edit rs myapp-replicaset
kubectl edit rs myapp-replicaset --save-config  # save the config file to the cluster

#Namespaces. K8S creates 3 by default:
kube-system  # for system pods
default  # for user pods
kube-public  # for public pods
kubectl create namespace dev  # create a new namespace called dev
kubectl config set-context --current --namespace=dev  # set the current context to the dev namespace
kubectl config set-context --current --namespace=prod  # set the current context to the prod namespace
kubectl config set-context $(kubectl config current-context) --namespace=dev  # set the current context to the dev namespace
kubectl config set-context $(kubectl config current-context) --namespace=prod  # set the current context to the prod namespace
#namespaces can be defined in the metadata section of pod and other object definitions. If not defined, they will be created in the default namespace.

#Deployments automatically create ReplicaSets with the name of the deployment and create pods including the name of the deployment

Reference (Bookmark this page for exam. It will be very handy):

https://kubernetes.io/docs/reference/kubectl/conventions/

# Create an NGINX Pod

kubectl run nginx --image=nginx

# Generate POD Manifest YAML file (-o yaml). Don't create it(--dry-run)

kubectl run nginx --image=nginx --dry-run=client -o yaml

# Create a deployment

kubectl create deployment --image=nginx nginx

# Generate Deployment YAML file (-o yaml). Don't create it(--dry-run)

kubectl create deployment --image=nginx nginx --dry-run=client -o yaml

# Generate Deployment YAML file (-o yaml). Don’t create it(–dry-run) and save it to a file.

kubectl create deployment --image=nginx nginx --dry-run=client -o yaml > nginx-deployment.yaml

# Make necessary changes to the file (for example, adding more replicas) and then create the deployment.

kubectl create -f nginx-deployment.yaml

# OR

# In k8s version 1.19+, we can specify the --replicas option to create a deployment with 4 replicas.

kubectl create deployment --image=nginx nginx --replicas=4 --dry-run=client -o yaml > nginx-deployment.yaml
kubectl create deployment httpd-frontend --image=httpd:2.4-alpine --replicas=4
kubectl create deployment httpd-frontend --image=httpd:2.4-alpine --replicas=4 --dry-run=client -o yaml > httpd-frontend-deployment.yaml