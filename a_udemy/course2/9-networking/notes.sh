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
cat /proc/sys/net/ip4/ip_forward