# High level
1. Create 3 VMs: 1 master and 2 workers. In a real cluster you need 3 masters because of the 2/N + 1 quorum requirement for etcd server.
2. Install containerd on all 3 nodes. 
3. Install kubeadm on all 3 nodes.
4. Initialize the master server.
5. Install pod network on all 3 servers
6. Join the worker nodes to the master.

The vagrant file used in the next video is available here:
https://github.com/kodekloudhub/certified-kubernetes-administrator-course
Here's the link to the documentation:
https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/

# On all 3 nodes
sudo apt-get update; sudo apt upgrade -y; sudo apt-get install -y apt-transport-https ca-certificates curl gpg
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.37/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.37/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update; sudo apt-get install -y kubelet kubeadm kubectl; sudo apt-mark hold kubelet kubeadm kubectl
sudo apt install -y containerd
sudo mkdir -p /etc/containerd
containerd config default | sed 's/SystemdCgroup = false/SystemdCgroup = true/' | sudo tee /etc/containerd/config.toml
sudo systemctl restart containerd

sudo swapoff -a
# Permanently disable swap by commenting out any swap line in /etc/fstab:
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay; sudo modprobe br_netfilter

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sudo sysctl --system; sudo systemctl restart containerd

# Initialize Control Plane Node. The advertised address comes from the primary interface from "ip addr" or "ip a"
sudo kubeadm init --apiserver-advertise-address 192.168.1.161 --pod-network-cidr "10.244.0.0/16" --upload-certs
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
To test: kubectl get nodes
# add flannel networking
# If you use custom podCIDR (not 10.244.0.0/16) you first need to download the YAML below and modify the network to match your one.
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
sudo kubeadm token create --print-join-command  # provides command used to run on worker nodes

# On worker nodes
sudo kubeadm join 192.168.1.161:6443 --token <token> --discovery-token-ca-cert-hash sha256:<hash> from output above