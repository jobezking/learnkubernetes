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