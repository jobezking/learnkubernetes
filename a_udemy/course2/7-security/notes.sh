## Certificate Authority (CA)
#Server certificates
# Server certificate for kube-api-server
openssl genrsa -out ca.key 2048                                     # generate a private key for the CA
openssl req -new -key ca.key -subj "/CN=KUBERNETES-CA" -out ca.csr  # certificate signing request
openssl x509 -req -in ca.csr -signkey ca.key -out ca.crt            # self-sign the CA certificate
#etcd server
openssl genrsa -out etcdserver.key 2048  
openssl req -new -key etcdserver.key subj "/CN=kube-etcdserver" -out etcdserver.csr
openssl x509 -req -in etcdserver.csr -signkey etcdserver.key -out etcdserver.crt 
#kube-api-server
openssl genrsa -out apiserver.key 2048  
openssl req -new -key apiserver.key subj "/CN=kube-apiserver" -out apiserver.csr
openssl x509 -req -in apiserver.csr -signkey apiserver.key -out apiserver.crt 
#kubelet server
openssl genrsa -out kubeletserver.key 2048  
openssl req -new -key kubeletserver.key subj "/CN=kubelet-server" -out kubeletserver.csr
openssl x509 -req -in kubeletserver.csr -signkey kubeletserver.key -out kubeletserver.crt 
# Client certificates
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