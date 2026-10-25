# chapter 3
#Create a Pod named nginx that uses the container image nginx:1.27.4-alpine.
kubectl run nginx --image=nginx:1.27.4-alpine
# Identify the node the Pod has been scheduled on.
kubectl get pod nginx -o wide
# Evict all Pods from the node that runs the Pod at once
kubectl drain --ignore-daemonsets node01-e --force
# chapter 4: upgrade
sudo apt update
sudo apt-cache madison kubeadm
sudo apt-mark unhold kubeadm && \
sudo apt-get update && sudo apt-get install -y kubeadm='1.37.8-*' && \
sudo apt-mark hold kubeadm
kubeadm version
sudo kubeadm upgrade plan
sudo kubeadm upgrade apply v1.37.8
kubectl drain controlplane-e --ignore-daemonsets --force
sudo apt-mark unhold kubelet kubectl && \
sudo apt-get update && sudo apt-get install -y kubelet='1.37.8-*' kubectl='1.38.x-*' && \
sudo apt-mark hold kubelet kubectl
sudo systemctl daemon-reload; sudo systemctl restart kubelet
kubectl uncordon controlplane-e
        ### workers ###
sudo apt-mark unhold kubeadm kubectl && \
sudo apt-get update && sudo apt-get install -y kubeadm='1.37.8-*' kubectl='1.37.8-*' && \
sudo apt-mark hold kubeadm kubectl
sudo kubeadm upgrade node
kubectl drain node01-e --ignore-daemonsets --force
sudo apt-mark unhold kubelet && \
sudo apt-get update && sudo apt-get install -y kubelet='1.38.x-*' && \
sudo apt-mark hold kubelet
sudo systemctl daemon-reload; sudo systemctl restart kubelet
kubectl uncordon node01-e
#chapter 5
# which version of etcd is running?
kubectl get pods -n kube-system | grep etcd
kubectl describe pod etcd-controlplane-e -n kube-system | grep Image:
# Use etcdctl and etcdutl to back up etcd to /opt/etcd.bak and restore etcd from the snapshot file using data directory /var/bak
sudo ETCDCTL_API=3 etcdctl \
  --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key snapshot save /opt/etcd.bak

etcdutl --data-dir /var/bak snapshot restore /opt/etcd.bak
# Chapter 6
kubectl config view
kubectl config current-context
kubectl config use-context
kubectl config set-credentials myuser --client-key=myuser.key --client-certificate=myuser.crt --embed-certs=true
#Create a ClusterRole with the name service-view to the API resources services with the operations get and list
kubectl create clusterrole service-view --verb=verb --resource=resource.group [--resource-name=resourcename] [--dry-run=server|client|none]
kubectl create clusterrole service-view --verb=get,list --resource=services
# Create the RoleBinding named ellasmith-service-view in the development namespace
kubectl create rolebinding NAME --clusterrole=NAME|--role=NAME [--user=username] [--group=groupname] [--serviceaccount=namespace:serviceaccountname] [--dry-run=server|client|none]
kubectl create rolebinding ellasmith-service-view --clusterrole=service-view --user=ellasmith --namespace=development
# Map the user ellasmith to the ClusterRole service-view.
kubectl create clusterrolebinding NAME --clusterrole=NAME [--user=username] [--group=groupname] [--serviceaccount=namespace:serviceaccountname] [--dry-run=server|client|none]
kubectl create clusterrolebinding ellasmith-service-view --clusterrole=service-view --user=ellasmith
Create a ClusterRole with the name combined. Aggregate cluster roles based on the matching label key-value pair rbac.cka.cncf.com/aggregate: "true"
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: combined
aggregationRule:
  clusterRoleSelectors:
  - matchLabels:
      rbac.cka.cncf.com/aggregate: "true"
rules: []
# Render the selected rules of the ClusterRole combined. How many rules do you see?
kubectl describe clusterrole combined
kubectl get clusterrole combined -o yaml

#Create a servcice account named api-access in new namespace called apps
kubectl create ns apps
kubectl create serviceaccount api-access -n apps
# Create a cluster role with the name api-clusterrole
kubectl create clusterrole api-clusterrole --verb=get,list,watch --resource=pods,services --dry-run=client -o yaml > api-clusterrole.yaml
# Create a clusterrolebinding with the name api-clusterrolebinding
kubectl create clusterrolebinding api-clusterrolebinding --clusterrole=api-clusterrole -serviceaccount=apps:api-access --dry-run=client -o yaml > crb.yml
# Create a pod named operator with the image nginx:1.21.1 in namespace apps with port 80 exposed. Assign sa api-access to pod
kubectl run operator --image nginx:1.21.1 --port=80 -n apps --dry-run=client -o yaml > operator.yml
apiVersion: v1
kind: Pod
metadata:
  name: operator
  namespace: apps
spec:
  serviceAccountName: api-access
  containers:
  - name: operator
    ports:
    - containerPort: 80
    image: nginx
# Create pod named disposable with image nginx:1.21.1 in namespace rm. Do not assign service account to pod
kubectl create ns rm
kubectl run disposable --image nginx:1.21.1 -n rm
# open an interactive shell to pod operator
kubectl exec -it operator -n apps -- sh
# use curl to make an API call to list the pods in namespace rm
TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)

curl -s \
  -H "Authorization: Bearer $TOKEN" \
  --cacert /var/run/secrets/kubernetes.io/serviceaccount/ca.crt \
  https://kubernetes.default.svc/api/v1/namespaces/rm/pods
# Chapter 7
kubectl get crds
# Chapter 8
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm search repo <chart-name> --versions
helm install my-kube-prometheus-stack prometheus-community/kube-prometheus-stack --version 92.13.1
kubectl port-forward service/prometheus-operated 8080:9090  # Use the kubectl port-forward command to forward the local port 8080 to the port 9090 of the service
helm list
helm repo update
helm upgrade my-kube-prometheus-stack prometheus-community/kube-prometheus-stack
helm uninstall my-kube-prometheus-stack