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
kubectl -n kube-system describe pod etcd-controlplane
kubectl -n kube-system describe pod etcd-controlplane | grep '\--listen-client-urls'
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

https://kubernetes.io/docs/tasks/administer-cluster/configure-upgrade-etcd/#backing-up-an-etcd-cluster

https://github.com/etcd-io/website/blob/main/content/en/docs/v3.5/op-guide/recovery.md

https://www.youtube.com/watch?v=qRPNuT080Hk

### Complete Restore Process ###
# Step 1: Stop the kube-apiserver Execute the following commands:

mv /etc/kubernetes/manifests/kube-apiserver.yaml /tmp/
sleep 30

#Step 2: Restore the etcd snapshot

Run the command below to restore the snapshot:

etcdutl snapshot restore /opt/snapshot-pre-boot.db --data-dir /var/lib/etcd-from-backup
Expected output:

2025-04-24T09:38:07Z    info    snapshot/v3_snapshot.go:265     restoring snapshot
2025-04-24T09:38:07Z    info    membership/store.go:141 Trimming membership information from the backend...
2025-04-24T09:38:07Z    info    membership/cluster.go:421       added member
2025-04-24T09:38:07Z    info    snapshot/v3_snapshot.go:293     restored snapshot
Step 3: Update the etcd configuration

Open the etcd configuration file for editing:

vi /etc/kubernetes/manifests/etcd.yaml
Modify the volumes section as follows:

From:

  volumes:
  - hostPath:
      path: /etc/kubernetes/pki/etcd
      type: DirectoryOrCreate
    name: etcd-certs
  - hostPath:
      path: /var/lib/etcd                    # OLD directory
      type: DirectoryOrCreate
    name: etcd-data
To:

  volumes:
  - hostPath:
      path: /etc/kubernetes/pki/etcd
      type: DirectoryOrCreate
    name: etcd-certs
  - hostPath:
      path: /var/lib/etcd-from-backup        # NEW restored directory
      type: DirectoryOrCreate
    name: etcd-data
Upon saving this file, the etcd pod will restart automatically due to static pod behavior.

Step 4: Restart the kube-apiserver

Move the kube-apiserver manifest back to its original location:

mv /tmp/kube-apiserver.yaml /etc/kubernetes/manifests/
Wait for 60 seconds to allow the kube-apiserver to start.

Step 5: Restart other control plane components

Execute the following commands to restart additional components:

# Restart kube-controller-manager
mv /etc/kubernetes/manifests/kube-controller-manager.yaml /tmp/
sleep 20
mv /tmp/kube-controller-manager.yaml /etc/kubernetes/manifests/

# Restart kube-scheduler
mv /etc/kubernetes/manifests/kube-scheduler.yaml /tmp/
sleep 20
mv /tmp/kube-scheduler.yaml /etc/kubernetes/manifests/

# Restart kubelet
systemctl restart kubelet
Step 6: Monitor the restart process

Use the following command to monitor the restart:

watch crictl ps
Key indicators to observe:

All components should show STATUS = Running
The entire process should take approximately 2-3 minutes.
Step 7: Verify the restore

Run the commands below to check resource status across all namespaces:

# Check all resources across all namespaces
kubectl get deployments,services --all-namespaces

# Verify specific resources if needed
kubectl get pods --all-namespaces
kubectl get nodes
You should now observe all the resources that existed at the time the snapshot was taken.