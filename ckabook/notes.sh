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

kubectl run frontend --image=nginx:1.29.2 --port=80 -o yaml --dry-run=client > pod.yaml
vim pod.yaml
kubectl apply -f pod.yaml

sudo kubeadm init --pod-network-cidr=10.244.0.0/16

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f [podnetwork].yaml https://kubernetes.io/docs/concepts/cluster-administration/addons/