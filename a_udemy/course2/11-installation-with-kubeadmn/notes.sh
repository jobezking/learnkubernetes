# High level
1. Create 3 VMs: 1 master and 2 workers. In a real cluster you need 3 masters because of the 2/N + 1 quorum requirement for etcd server.
2. Install containerd on all 3 nodes. 
3. Install kubeadm on all 3 nodes.