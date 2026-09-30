Chapter 1
Chapter 2
Chapter 3
Chapter 4
Understand why you need to provision infrastructure
Know how to create a Kubernetes cluster from scratch # use documentation in VMWare
Practice the cluster upgrade process in VMWare
Have a theoretical understanding of high-availability cluster topologies

Create a cluster with four nodes: one control plane node, and three worker nodes. Version 1.32.1
Create a Pod named nginx that uses the container image nginx:1.27.4-alpine. 
Identify the node the Pod has been scheduled on. 
Evict all Pods from the node that runs the Pod at once. Do not use the kubectl delete pod command to perform the operation. 
Ensure that the Pod is not running anymore.
Upgrade all nodes of the cluster from Kubernetes 1.32.1 to 1.32.2.

Chapter 5
Practice backing up etcd
Know how to restore etcd
Restoring etcd requires the use of the executable etcdutl. 
You will need to point the command to the snapshot file created in the backup process, and to a target directory used to extract the etcd data into. 
Just extracting the etcd data into a directory doesn’t tell the etcd process to use it. 
You need to configure the host path to the directory in the configuration for etcd.