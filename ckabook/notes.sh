# Kubernetes primitive structure:
API Version: defines structure of the primitive
Kind: defines the type of primitive i.e. pod, service etc.
Metadata: higher level info about object
Spec: specification. The desired state after object has been created
Status: the actual state of the object

kubectl explain: time-saving tool during exam i.e.
kubectl explain pods.spec.containers
kubectl explain deployment.spec.strategy.rollingUpdate

kubectl run frontend --image=nginx:1.29.0 --port=80
kubectl edit pod frontend
kubectl patch pod frontend -p '{"spec":{"containers":[{"name":"frontend",\
"image":"nginx:1.29.2"}]}}'
kubectl delete pod frontend
kubectl delete pod frontend --now

kubectl get pod web-app -o yaml

kubectl apply -f nginx-deployment.yaml
kubectl get deployment nginx-deployment -o yaml
kubectl delete -f nginx-deployment.yaml

# kubectl run options: --image; --port; --env; --rm; --dry-run=client; -o yaml
#Pod lifecycle: Pending -> Running -> Succeeded/Failed
# Pending: Pod has been accepted by the Kubernetes system, but one or more of the container images has not been created. This includes time before being scheduled as well as time spent downloading images over the network, which could take a while.
# Running: The Pod has been bound to a node, and all of the containers have been created. At least one container is still running, or is in the process of starting or restarting.
# Succeeded: All containers in the Pod have terminated in success, and will not be restarted.
# Failed: All containers in the Pod have terminated, and at least one container has terminated in failure. That is, the container either exited with non-zero status or was terminated by the system.
# Unkown: For some reason the state of the Pod could not be obtained, typically due to an error in communicating with the host of the Pod.
# Container level restart policy: Always, OnFailure, Never

kubectl run frontend --image=nginx:1.29.2 --port=80 -o yaml --dry-run=client > pod.yaml
vim pod.yaml
kubectl apply -f pod.yaml

kubectl describe pods hazelcast
kubectl logs hazelcast
kubectl exec -it hazelcast -- /bin/sh
kubectl delete pod hazelcast --grace-period=0 --force

# To send a single command
kubectl exec hazelcast -- ls /opt/hazelcast
# create temporary pod to run a command in the cluster
kubectl run -i --tty temp-pod --image=busybox --rm -it --restart=Never -- ls /opt
# namespaces
kubectl get namespaces
kubectl create namespace my-namespace
kubectl get namespace my-namespace -o yaml > my-namespace.yaml
kubectl run pod --image=nginx:1.25.1 -n my-namespace
kubectl get pods -n my-namespace
kubectl delete namespace my-namespace  # will automatically delete pods and other objects inside namespace

sudo kubeadm init --pod-network-cidr=10.244.0.0/16

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f [podnetwork].yaml https://kubernetes.io/docs/concepts/cluster-administration/addons/
kubeadm token create --print-join-command

kubectl create ns kube-flannel
kubectl label --overwrite ns kube-flannel pod-security.kubernetes.io/ enforce=privileged
helm repo add flannel https://flannel-io.github.io/flannel/
helm install flannel --set podCidr="10.244.0.0/16" --namespace kube-flannel flannel/flannel

# Upgrading
# start with control plane
sudo apt update
sudo apt-cache madison kubeadm
sudo apt-mark unhold kubeadm && sudo apt-get update && sudo apt-get install \
  -y kubeadm=1.31.5-1.1 && sudo apt-mark hold kubeadm
sudo apt-get update && sudo apt-get install -y --allow-change-held-packages \
  kubeadm=1.31.5-1.1
kubeadmn version
sudo kubeadm upgrade plan
sudo kubeadm upgrade apply v1.31.5

kubectl drain kube-control-plane --ignore-daemonsets
sudo apt-mark unhold kubelet kubectl && sudo apt-get update && sudo \
  apt-get install -y kubelet=1.31.5-1.1 kubectl=1.31.5-1.1 && sudo apt-mark \
  hold kubelet kubectl
sudo systemctl daemon-reload
sudo systemctl restart kubelet
kubectl uncordon kube-control-plane
kubectl get nodes
#now workers
sudo apt-mark unhold kubeadm && sudo apt-get update && sudo apt-get install \
  -y kubeadm=1.31.5-1.1 && sudo apt-mark hold kubeadm
kubeadm version
sudo kubeadm upgrade node
kubectl drain kube-worker-1 --ignore-daemonsets
sudo apt-mark unhold kubelet kubectl && sudo apt-get update && sudo apt-get \
  install -y kubelet=1.31.5-1.1 kubectl=1.31.5-1.1 && sudo apt-mark hold kubelet \
  kubectl
sudo systemctl daemon-reload
sudo systemctl restart kubelet
kubectl uncordon kube-worker-1
kubectl get nodes

# etcd backup/restore
#to install etcdctl and etcdutl
sudo apt update && sudo apt install -y etcd-client && echo 'export ETCDCTL_API=3' >> ~/.bashrc

sudo ETCDCTL_API=3 etcdctl --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key \
  snapshot save /opt/etcd-backup.db

sudo ETCDCTL_API=3 etcdctl snapshot restore /opt/etcd-backup.db \
  --data-dir=/var/lib/etcd-backup

# OR

sudo ETCDCTL_API=3 etcdutl --data-dir=/var/lib/from-backup snapshot restore \
  /opt/etcd-backup.db

# Authentication and authorization
$HOME/.kube/config # contains the credentials for the cluster used by kubectl to authenticate to the cluster. 
# contains information about the cluster, user, and context.
kubectl config view # view the contents of the kubeconfig file
kubectl config get-contexts; kubectl config current-context # list all contexts in the kubeconfig file
kubectl config use-context <context-name> # switch to a different context
kubectl config set-credentials myuser \
  --client-key=myuser.key --client-certificate=myuser.crt \
  --embed-certs=true # set credentials for a user in the kubeconfig file
# role: API primitives that define a set of permissions for a user or group of users. Roles can be created at the namespace level or cluster level.
# default roles: cluster-admin, admin, edit, view
# rolebinding: API primitive that binds a role to a user or group of users. RoleBindings can be created at the namespace level or cluster level.
kubectl create role read-only --verb=get,list,watch --resource=pods --namespace=default # create a role that allows read-only access to pods in the default names
kubectl create rolebinding alice-pod-reader --role=pod-reader --user=alice #create a role binding that binds the pod-reader role to a user named alice in the default namespace
kubectl create rolebinding read-only-binding --role=read-only --user=bmuschko
kubectl get rolebindings
kubectl get roles 
kubectl describe rolebinding read-only-binding # create a role binding that binds the read-only role to a user
kubectl auth can-i --list --as bmuschko # check what actions a user can perform in the cluster
# Service accounts: API primitive that provides an identity for processes that run in a pod. Service accounts can be used to authenticate to the Kubernetes API server and access resources in the cluster.
kubectl create serviceaccount my-service-account # create a service account named my-service-account in the default namespace
kubectl get serviceaccounts # list all service accounts in the default namespace
kubectl describe serviceaccount my-service-account # view details of a service account
# assigning service account to a pod cannot be done imperatively requires declarative approach (yaml file)

# CRD: Custom Resource Definition is an API primitive that allows users to define their own custom resources in Kubernetes. CRDs can be used to extend the Kubernetes API with new resource types that are not included in the default Kubernetes API.
# Installing operator lifetime manager
curl -sL https://github.com/operator-framework/operator-lifecycle-manager/releases/download/v0.31.0/install.sh | bash -s v0.31.0
kubectl create -f https://operatorhub.io/install/argocd-operator.yaml
kubectl get csv -n openshift-operators
kubectl get csv -n operators
# Application:  group of kubernetes resources as defined by a manifest
# ApplicationSet: a group or set of Application resources
# App Project: logical grouping that defines which git repos, clusters, namespaces a set of applications can access. Multitenancy and security boundaries
kubectl get crds
kubectl describe crd applications.argoproj.io
# nginx-application.yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: nginx
spec:
  project: default
  source:
    repoURL: https://github.com/bmuschko/cka-study-guide.git
    targetRevision: HEAD
    path: ./ch07/nginx
  destination:
    server: https://kubernetes.default.svc
    namespace: default
#  kubectl apply -f nginx-application.yaml
kubectl describe application nginx
kubectl delete application nginx
kubectl get deployments,services,pods -l app=nginx
kubectl get deployments,pods -n operators

# Helm
helm repo list
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add jenkins https://charts.jenkins.io
helm repo update
helm search repo bitnami
helm install my-jenkins jenkins/jenkins --version 5.8.25 --set controller.adminPassword=admin123
kubectl get pods -n default -l app.kubernetes.io/instance=my-jenkins
helm show jenkins/jenkins
helm show values jenkins/jenkins
helm install my-jenkins jenkinsci/jenkins --version 4.6.4 --set controller.adminUser=boss --set controller.adminPassword=password \
-n jenkins --create-namespace
helm list -n
helm repo update
helm upgrade my-jenkins jenkinsci/jenkins --version 5.8.26
helm uninstall my-jenkins -n jenkins
# kustomize: tool for customizing kubernetes resource configuration. It allows you to define a base set of resources and then apply overlays to modify those resources for different environments or use cases.
kubectl kustomize <target>
kubectl apply -k <target>