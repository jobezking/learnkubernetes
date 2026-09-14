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