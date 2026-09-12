## Certificate Authority (CA)
### Server certificates
# Server certificate for kube-api-server
openssl genrsa -out ca.key 2048                                     # generate a private key for the CA
openssl req -new -key ca.key -subj "/CN=KUBERNETES-CA" -out ca.csr  # certificate signing request
openssl x509 -req -in ca.csr -signkey ca.key -out ca.crt            # self-sign the CA certificate
#etcd server
openssl genrsa -out etcdserver.key 2048  
openssl req -new -key etcdserver.key subj "/CN=kube-etcdserver" -out etcdserver.csr
#openssl x509 -req -in etcdserver.csr -signkey etcdserver.key -out etcdserver.crt
openssl x509 -req -in etcdserver.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out etcdserver.crt
#kube-api-server
openssl genrsa -out apiserver.key 2048  
openssl req -new -key apiserver.key subj "/CN=kube-apiserver" -out apiserver.csr -config openssl.cnf
openssl x509 -req -in apiserver.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out apiserver.crt -extensions v3_req -extfile openssl.cnf -days 1000
#kubelet server  create one for each node named after each node i.e. kubelet-node01, server01, kubelet-node02
openssl genrsa -out kubelet-node.key 2048  
openssl req -new -key kubelets-node.key subj "/CN=kubelet-node" -out kubelet-node.csr
#openssl x509 -req -in kubeletserver.csr -signkey kubeletserver.key -out kubeletserver.crt
openssl x509 -req -in kubelet-node.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out kubelet-node.crt

### Client certificates
# admin user
openssl genrsa -out admin.key 2048                                 # generate a private key for the client
openssl req -new -key admin.key -subj "/CN=kube-admin" -out admin.csr  # certificate signing request
openssl x509 -req -in admin.csr -CA ca.crt -CAkey ca.key -out admin.crt  # sign the client certificate with the CA using server certificate key
# repeat for all other components that access the kube-api-server (kubelet, kube-proxy, kube-controller-manager, kube-scheduler, etcd, etc.)
#kube-scheduler
openssl genrsa -out scheduler.key 2048                                 # generate a private key for the client
openssl req -new -key scheduler.key -subj "/CN=system:kube-scheduler" -out scheduler.csr  # certificate signing request
openssl x509 -req -in scheduler.csr -CA ca.crt -CAkey ca.key -out scheduler.crt  # sign the client certificate with the CA using server certificate key
#kube-controller-manager
openssl genrsa -out controller-manager.key 2048                                 # generate a private key for the client
openssl req -new -key controller-manager.key -subj "/CN=system:kube-controller-manager" -out controller-manager.csr  # certificate signing request
openssl x509 -req -in controller-manager.csr -CA ca.crt -CAkey ca.key -out controller-manager.crt  # sign the client certificate with the CA using server certificate key
#kube-proxy
openssl genrsa -out kube-proxy.key 2048                                 # generate a private key for the client
openssl req -new -key kube-proxy.key -subj "/CN=system:kube-proxy" -out kube-proxy.csr  # certificate signing request
openssl x509 -req -in kube-proxy.csr -CA ca.crt -CAkey ca.key -out kube-proxy.crt  # sign the client certificate with the CA using server certificate key
#apiserver-kubelet-client
openssl genrsa -out apiserver-kubelet-client.key 2048                                 # generate a private key for the apiserver-kubelet-client
openssl req -new -key apiserver-kubelet-client.key -subj "/CN=system:apiserver-kubelet-client" -out apiserver-kubelet-client.csr  # certificate signing request
openssl x509 -req -in apiserver-kubelet-client.csr -CA ca.crt -CAkey ca.key -out apiserver-kubelet-client.crt  # sign the client certificate with the CA using server certificate key
#apiserver-etcd-client
openssl genrsa -out etcd-client.key 2048                                 # generate a private key for the client
openssl req -new -key etcd-client.key -subj "/CN=system:etcd-client" -out etcd-client.csr  # certificate signing request
openssl x509 -req -in etcd-client.csr -CA ca.crt -CAkey ca.key -out etcd-client.crt  # sign the client certificate with the CA using server certificate key
#kubelet-client
openssl genrsa -out kubelet-client.key 2048                                 # generate a private key for the client
openssl req -new -key kubelet-client.key -subj "/CN=system:kubelet-client" -out kubelet-client.csr  # certificate signing request
openssl x509 -req -in kubelet-client.csr -CA ca.crt -CAkey ca.key -out kubelet-client.crt  # sign the client certificate with the CA using server certificate key

curl https://kube-apiserver:6443/api/v1/pods --key admin.key --cert admin.crt --cacert ca.crt

# To view certificates
cat /etc/kubernetes/manifests/kube-apiserver.yaml # look for *.crt and *.key files
openssl x508 -in /etc/kubernetes/pki/apiserver.crt -text -noout # view certificate information

/etc/kuberntes/pki/apiserver.crt
/etc/kuberntes/pki/apiserver.key
/etc/kuberntes/pki/ca.crt
/etc/kuberntes/pki/apiserver-kubelet-client.crt
/etc/kuberntes/pki/apiserver-kubelet-client.key
/etc/kuberntes/pki/apiserver-etcd-client.crt
/etc/kuberntes/pki/apiserver-etcd-client.key
/etc/kuberntes/pki/ca.crt

journalctl -u etcd.service -l

crictl ps -a  # view containers
crictl logs [containername] # to view logs


#Provision user certificate process.
1. User generates certificate:                  openssl genrsa -out adam.key 2048
2. User generates certificate signing request:  openssl req -new -key adam.key -subj "/CN=adam" -out adam.csr
3. cat adam.csr | base64 -w 0  #Contents of key go into adam-cr.yaml

# carried out by kubectl-controller-manager
kubectl apply -f adam-csr.yaml
kubectl get csr
kubectl certificate approve adam-csr
kubectl certificate deny <username>
kubectl delete csr <username>
kubectl get csr adam -o yaml

#kubeconfig
kubectl config view
kubectl config view -kubeconfig=<config file>
kubectl config use-context <context-name>
kubectl config --kubeconfig=/root/my-kube-config use-context research
kubectl config -h
export KUBECONFIG=$HOME/my-kube-config

#APIs
curl https://kube-master:6443/version
curl https://kube-master:6443/api/v1/pods
kubectl proxy   # authenticates for API requests
curl http://localhost:8001 -k  # shows objects that you can run curl requests against i.e. /api, /healthz etc

# Authorization/Access commands
cat /etc/kubernetes/manifests/kube-apiserver.yaml
ps -aux | grep authorization
kubectl describe pod kube-apiserver-controlplane -n kube-system
kubectl get roles [--namespace=]
kubectl get rolebindings [--namespace=]
kubectl config view
# Roles and Rolebindings are namespace-scoped. Resources are either namespaced or cluster-scoped
kubectl api-resources --namespaced=true
kubectl api-resources --namespaced=false
kubectl describe role kube-proxy -n kube-system
kubectl get pods --as dev-user
kubernetes create role --help
kubectl create role developer --namespace=default --verb=list,create,delete --resource=pods
kubectl create rolebinding dev-user-binding --namespace=default --role=developer --user=dev-user
kubectl auth can-i create deployments
kubectl auth can-i delete nodes
kubectl auth can-i create deployments --as dev-user
kubectl auth can-i create pods --as dev-user
kubectl auth can-i create pods --as dev-user --namespace test
# clusterroles. Below are examples. Roles are defined.
cluster admin  #view, create, delete nodes
storage admin  #view, create, delete PVs (persistent volumes)
#service accounts
# Every namespace has default service account which is automatically attached to pods on their creation
# service account gets mounted at a projected volume in pod 
kubectl get pods -o yaml | grep serviceAccountName
kubectl get serviceaccount
kubectl describe serviceaccount default       # default k8s svc accnt
kubectl describe pod my-kubernetes-dashboard | grep -i 'Service Account'
kubectl exec -it my-kubernetes-dashboard ls /var/run/secrets/kubernetes.io/serviceaccount
kubectl create serviceaccount dashboard-sa
# to associate service account with a pod, use field serviceAccountName in pod's spec field i.e. spec.serviceAccountName
# if you do not want the token mounted in a pod, you can use the field automountServiceAccountToken: false either in the service
# account definition or the pods spec definition
kubectl create token dashboard-sa --duration 2h # create token whose output can be used in application calls to kubernetes API