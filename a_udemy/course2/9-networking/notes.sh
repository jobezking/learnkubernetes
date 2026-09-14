cni0: containerd ethernet interface
docker0: Docker ethernet interface

Kubernetes networking requirement
Each node must be connected to network.
Internet interface i.e. eth0 with IP address configured
IP address unique on network
unique hostname
unique MAC address
open ports
kube-api (master): 6443
etcd (master): 2379
etcd (master if more than one master node): 2380
kube-controller-manager (master): 10257
kube-scheduler (master): 10259
kubelet (master and worker): 10250
services (worker): 30000-32767
http://kubernetes.io/docs/reference/networking/ports-and-protocols

ip link
ip addr
ip route
arp 
route
ip addr add 192.168.1.10/24 dev eth0
ip route add 192.168.1.0/24 via 192.168.2.1
netstat -plnt
netstat -npa | grep etcd
cat /proc/sys/net/ip4/ip_forward

/opt/cni/bin  # containerd networking folder
ls /etc/cni/net.d/

kubectl get service
iptables -L -t nat | grep servicename

# CoreDNS
cat /etc/coredns/Corefile 
kubectl get configmap -n kube-system
cat /var/lib/kubelet/config.yaml

kubectl get ingress
kubectl describe ingress ingress-wear-watch

in k8s version 1.20+ we can create an Ingress resource from the imperative way like this:-

Format - kubectl create ingress <ingress-name> --rule="host/path=service:port"

Example - kubectl create ingress ingress-test --rule="wear.my-online-store.com/wear*=wear-service:80"

Find more information and examples in the below reference link:-

https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#-em-ingress-em-

References:-

https://kubernetes.io/docs/concepts/services-networking/ingress

https://kubernetes.io/docs/concepts/services-networking/ingress/#path-types