kubectl get nodes # check node status
cat /etc/*release # check OS version
kubectl drain <node-name> --ignore-daemonsets --delete-local-data # do before taking down node for maintenance
# pods are recreated on another node and node is marked as unschedulable
kubectl uncordon <node-name> # do after maintenance is complete to allow scheduling of pods on the node again
kubectl cordon <node-name> # mark node as unschedulable to prevent scheduling of pods on the node
kubectl get pods -o wide # check where pods are running

# Upgrade k8s one minor version at a time, e.g. 1.25.x -> 1.26.x -> 1.27.x
# First upgrade master node then upgrade worker nodes
kubeadm version # check current version of kubeadm
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

#On the controlplane node:
#Use any text editor you prefer to open the file that defines the Kubernetes apt repository.

vim /etc/apt/sources.list.d/kubernetes.list
#Update the version in the URL to the next available minor release, i.e v1.35.

deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.35/deb/ /
#After making changes, save the file and exit from your text editor. Proceed with the next instruction.

apt update

apt-cache madison kubeadm
#Based on the version information displayed by apt-cache madison, it indicates that for Kubernetes version 1.35.0, one of the available package versions is 1.35.0-1.1. Therefore, to install kubeadm for Kubernetes v1.35.0, use the following command:

apt-get install kubeadm=1.35.0-1.1
#Run the following command to upgrade the Kubernetes cluster.

kubeadm upgrade plan v1.35.0
kubeadm upgrade apply v1.35.0

#Note that the above steps can take a few minutes to complete.
#Now, upgrade the Kubelet version. Also, mark the node (in this case, the "controlplane" node) as schedulable.

apt-get install kubelet=1.35.0-1.1
#Run the following commands to refresh the systemd configuration and apply changes to the Kubelet service:

systemctl daemon-reload
systemctl restart kubelet

#backup
kubectl get all --all-namespaces -o yaml > backup.yaml # backup all resources in the cluster
etcdctl snapshot save backup.db # backup etcd cluster

#restore
sudo systemctl stop kube-apiserver kube-controller-manager kube-scheduler kubelet etcd # stop k8s services
etcdctl snapshot restore backup.db --data-dir /var/lib/etcd # restore etcd cluster from backup
sudo systemctl daemon-reload
systemctl start kube-apiserver kube-controller-manager kube-scheduler kubelet etcd # start k8s services

# WORKING WITH ETCDCTL & ETCDUTL
# etcdctl is a command line client for etcd
# To make use of etcdctl for tasks such as backup, verify it is running on API version 3.x:

etcdctl version

# Example:

# controlplane ~ ➜  
etcdctl version
etcdctl version: 3.5.16
API version: 3.5

# Backing Up ETCD
# Using etcdctl (Snapshot-based Backup)
# To take a snapshot from a running etcd server, use:

ETCDCTL_API=3 etcdctl \
  --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key snapshot save /backup/etcd-snapshot.db

# Required Options
# --endpoints points to the etcd server (default: localhost:2379)
# --cacert path to the CA cert
# --cert path to the client cert
# --key path to the client key

# Using etcdutl (File-based Backup)
# For offline file-level backup of the data directory:

etcdutl backup \
  --data-dir /var/lib/etcd \
  --backup-dir /backup/etcd-backup

# This copies the etcd backend database and WAL files to the target location.
# Checking Snapshot Status. You can inspect the metadata of a snapshot file using:

etcdctl snapshot status /backup/etcd-snapshot.db --write-out=table
# This shows details like size, revision, hash, total keys, etc. It is helpful to verify snapshot integrity before restore.

# Restoring ETCD Using etcdutl. To restore a snapshot to a new data directory:
etcdutl snapshot restore /backup/etcd-snapshot.db --data-dir /var/lib/etcd-restored

# To use a backup made with etcdutl backup, simply copy the backup contents back into /var/lib/etcd and restart etcd.

etcdctl snapshot save # used for creating .db snapshots from live etcd clusters.
etcdctl snapshot status # provides metadata information about the snapshot file.
etcdutl snapshot restore # used to restore a .db snapshot file.
etcdutl backup # performs a raw file-level copy of etcd’s data and WAL files without needing etcd to be running.