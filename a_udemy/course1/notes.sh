Components
API server: acts as front end for the Kubernetes control plane. It exposes the Kubernetes API and is responsible for handling REST requests, 
    validating them, and updating the corresponding objects in etcd.
etcd service: distributed reliable key-value store that stores all cluster data. It is used by the API server to persist the state of the cluster.
Kubelet service: an agent that runs on each node in the cluster. It ensures that containers are running in a Pod and reports back to the API server.
container runtime: underlying software that is responsible for running containers. It can be Docker, containerd, or any other compatible runtime.
controller manager: a component that runs controller processes. Each controller is a separate process that watches the state of the cluster 
    and makes changes to move the current state towards the desired state.
scheduler: distributing work and containers across nodes

master node: where the control plane components run. has kube-apiserver, etcd, controller-manager, and scheduler. It is responsible for 
    managing the cluster and making global decisions about the cluster (e.g., scheduling). 
worker nodes: has kubelet, container runtime, and kube-proxy. where (Docker) containers run.

kubernetes.io/docs/tasks/tools
1. https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
2. install virtualbox command line
3. https://minikube.sigs.k8s.io/docs/start/?arch=%2Flinux%2Fx86-64%2Fstable%2Fdebian+package
4. minikube config set driver virtualbox
5. minikube start
6. minikube status
7. kubectl get nodes
8. kubectl create deployment hello-minikube --image=registry.k8s.io/echoserver:1.10
9. kubectl get deployments
10. kubectl get pods
11. kubectl expose deployment hello-minikube --type=NodePort --port=8080 
12. minikube service hello-minikube --url
13. kubectl delete service hello-minikube --ignore-not-found
14. kubectl delete deployment hello-minikube
15. minikube stop

#A pod is the smallest and most basic building block in Kubernetes that runs your containers. 
# A deployment is a management controller that creates, scales, and updates pods automatically. 
# While a pod does the actual work, a deployment manages the overall lifecycle and health of those pods

kubectl run podname --image=imagename   # podname cane be anything. imagename can be any image from dockerhub.
kubectl run web --image=nginx --port=80 # run pod named web with nginx container and port 80 exposed
kubectl get pods
kubectl describe pod web
kubectl create deployment web --image=nginx # create deployment named web with nginx image
kubectl get deployments
kubectl describe deployment web
kubectl scale deployment web --replicas=3 # scale deployment named web to 3 replicas
kubectl delete pod web # delete pod named web

# YAML files contain 4 main sections: apiVersion, kind, metadata, and spec and are top level or root level properties and required fields.
# The apiVersion specifies the version of the Kubernetes API to use for the object.
# The kind specifies the type of object being created (e.g., Pod, Deployment, Service).
# The metadata section contains information about the object, such as its name and labels.
# The spec section defines the desired state of the object, including its configuration and behavior.

kubectl apply -f replica_controller_definition.yml
kubectl get replicationcontroller or kubectl get rc
kubectl get replicaset or kubectl get rs
kubectl scale --replicas=4 rs/rs-name
kubectl scale --replicas=6 -f replica_controller_definition.yml  # will not update file
kubectl scale --replicas=6 -f replicaset.yml
kubectl get pods -l type=front-end
kubectl describe replicationcontroller rc-name
kubectl describe replicaset rs-name
kubectl delete replicationcontroller rc-name
kubectl delete replicaset rs-name
#
#