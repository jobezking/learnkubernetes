Allowed during exam:
Reference manual: https://kubernetes.io/docs 
Blog: https://kubernetes.io/blog 
Helm: https://helm.sh/docs

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

Chapter 6 see sheet
Chapter 7:
know how to install operators
acquire high level understanding of configurable options for CRD schema
1. Navigate to the directory app-a/ch07/mongodb-operator of the checked-out GitHub repository bmuschko/cka-study-guide. 
Install the operator using the following command: kubectl apply -f mongodbcommun⁠ity.​mongodb.com_mongodbcommunity.yaml. 
List all CRDs using the appropriate kubectl command. Can you identify the CRD that was installed by the installation procedure? 
Inspect the schema of the CRD. What are the type and property names of this CRD?
2. Navigate to the directory app-a/ch07/backup-crd of the checked-out GitHub repository bmuschko/cka-study-guide. 
Create the CRD from the file backup-resource.yaml. Retrieve the details for the Backup custom resource created in the previous step. 
Create a CR named nginx-backup for the CRD in the default namespace. 
Provide the following property values:
cronExpression: 0 0 * * * 
podName: nginx 
path: /usr/local/nginx
Retrieve the details for the nginx-backup object created in the previous step.