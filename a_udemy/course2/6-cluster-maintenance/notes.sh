kubectl get nodes # check node status
cat /etc/*release # check OS version
kubectl drain <node-name> --ignore-daemonsets --delete-local-data # do before taking down node for maintenance
# pods are recreated on another node and node is marked as unschedulable
kubectl uncordon <node-name> # do after maintenance is complete to allow scheduling of pods on the node again
kubectl cordon <node-name> # mark node as unschedulable to prevent scheduling of pods on the node
kubectl get pods -o wide # check where pods are running

# Upgrade k8s one minor version at a time, e.g. 1.25.x -> 1.26.x -> 1.27.x
# First upgrade master node then upgrade worker nodes
kubeadm upgrade plan # check for available upgrades

#Upgrade master node
sudo apt-get upgrade -y kubeadm=<version> # upgrade kubeadm to the specified version
kubeadm upgrade apply <version> # upgrade master node to the specified version

sudo apt-get upgrade -y kubelet=<version>
sudo systemctl daemon-reload
sudo systemctl restart kubelet
kubectl get nodes # check node status

#Upgrade worker nodes
kubectl drain <node-name> --ignore-daemonsets --delete-local-data # drain the node before upgrade
sudo apt-get upgrade -y kubeadm=<version>
sudo apt-get upgrade -y kubelet=<version>
kubeadm upgrade node config --kubelet-version <version> # upgrade kubelet on the node
sudo systemctl daemon-reload
sudo systemctl restart kubelet
kubectl uncordon <node-name> # uncordon the node after upgrade