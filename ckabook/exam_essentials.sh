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

Chapter 8
Assume that the Helm and Kustomize executables are preinstalled
Become familiar with Artifact Hub
Practice commands needed to consume existing Helm charts
"In this exercise, you will use Helm to install Kubernetes objects needed for the open source monitoring solution Prometheus. 
The easiest way to install Prometheus on top of Kubernetes is with the help of the prometheus-operator Helm chart. 
You can search for the kube-prometheus-stack on Artifact Hub. 
Add the repository to the list of known repositories accessible by Helm with the name prometheus-community. 
Update to the latest information about charts from the respective chart repository. 
Run the Helm command for listing available Helm charts and their versions. 
Identify the latest chart version for kube-prometheus-stack. Install the chart kube-prometheus-stack. List the installed Helm chart. 
List the Service named prometheus-operated created by the Helm chart. The object resides in the default namespace. 
Use the kubectl port-forward command to forward the local port 8080 to the port 9090 of the Service. 
Open a browser and bring up the Prometheus dashboard. Stop port forwarding and uninstall the Helm chart. Create the directory named manifests. 
Within the directory, create two files: pod.yaml and configmap.yaml. The pod.yaml file should define a Pod named nginx with the image nginx:1.21.1.
 The configmap.yaml file defines a ConfigMap named logs-config with the key-value pair dir=/etc/logs/traffic.log. 
 Create both objects with a single, declarative command. Modify the ConfigMap manifest by changing the value of the key dir to /etc/logs/traffic-log.txt. 
 Apply the changes. Delete both objects with a single declarative command. Use Kustomize to set a common namespace t012 for the resource file pod.yaml. 
 The file pod.yaml defines the Pod named nginx with the image nginx:1.21.1 without a namespace. 
 Run the Kustomize command that renders the transformed manifest on the console." 