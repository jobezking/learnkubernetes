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