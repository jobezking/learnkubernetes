Section 1: RBAC Creation & Role Aggregation
• Create a ClusterRole named service-view that allows the get and list verbs on the services resource.
• Create a RoleBinding named ellasmith-service-view in the development namespace that maps the user ellasmith to the service-view ClusterRole.
• Create an empty ClusterRole named combined configured to dynamically aggregate other cluster roles using the label selector rbac.cka.cncf.com/aggregate: "true".
• Render the selected rules of the combined ClusterRole and count how many rules are currently visible.
• Create a ClusterRole named deployment-modify that allows the create, delete, patch, and update verbs on the deployments resource.
• Assign the label rbac.cka.cncf.com/aggregate: "true" to the deployment-modify ClusterRole.
• Render the selected rules of the combined ClusterRole again and count how many rules are visible after the aggregation.
Section 2: Permission Verification & Output Logging
• Run an authorization check to determine if the user ellasmith can list Services in the development namespace.
• Write the output (yes or no) of the development namespace check directly into a file named list-services-ellasmith.txt.
• Run an authorization check to determine if the user ellasmith can watch Deployments in the production namespace.
• Write the output (yes or no) of the production namespace check directly into a file named watch-deployments-ellasmith.txt.
Section 3: Service Account & Cross-Namespace Access Lab
• Create a new namespace named apps.
• Create a ServiceAccount named api-access inside the apps namespace.
• Create a ClusterRole named api-clusterrole and a ClusterRoleBinding named api-clusterrolebinding that grants the api-access ServiceAccount watch, list, and get verbs on pods.
• Deploy a Pod named operator using the nginx:1.21.1 image inside the apps namespace, expose container port 80, and assign the api-access ServiceAccount to it.
• Create another namespace named rm.
• Deploy a second Pod named disposable using the nginx:1.21.1 image inside the rm namespace without assigning any custom ServiceAccount.
• Open an interactive shell inside the operator pod.
• Execute a curl API call from inside the operator pod to list all Pods in the rm namespace and observe the response.
• Execute a second curl API call from inside the operator pod attempting to delete the disposable pod in the rm namespace, and evaluate if the response differs from the listing call.

# Section 1
1. Create the service-view ClusterRole:bash
kubectl create clusterrole service-view --verb=get,list --resource=services
Use code with caution.
2. Create the ellasmith-service-view RoleBinding:bash
kubectl create rolebinding ellasmith-service-view --clusterrole=service-view --user=ellasmith -n development
3. Create the aggregated combined ClusterRole:
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: combined
aggregationRule:
  clusterRoleSelectors:
  - matchLabels:
      ://cncf.com: "true"
rules: [] # The control plane will dynamically inject rules here
4. Render the selected rules and count them:bash
kubectl describe clusterrole combined
5. Create the deployment-modify ClusterRole:bash
kubectl create clusterrole deployment-modify --verb=create,delete,patch,update --resource=deployments
6. Assign the aggregation label to deployment-modify:bash
kubectl label clusterrole deployment-modify ://cncf.com"true"
7. Render the selected rules of combined again:bash
kubectl describe clusterrole combined

# Section 2: Permission Verification & Output Logging
1. Check if ellasmith can list Services in development and save output:bash
kubectl auth can-i list services --as=ellasmith -n development > list-services-ellasmith.txt

	• Contents of list-services-ellasmith.txt will be: yes (Granted via the RoleBinding in Section 1).
2. Check if ellasmith can watch Deployments in production and save output:bash
kubectl auth can-i watch deployments --as=ellasmith -n production > watch-deployments-ellasmith.txt

# Section 3 Service Account & Cross-Namespace Access Lab
1. Create the namespaces:bash
kubectl create namespace apps
kubectl create namespace rm

2. Create the ServiceAccount:bash
kubectl create serviceaccount api-access -n apps

3. Create the RBAC rules for the ServiceAccount:bash
kubectl create clusterrole api-clusterrole --verb=watch,list,get --resource=pods
kubectl create clusterrolebinding api-clusterrolebinding --clusterrole=api-clusterrole --serviceaccount=apps:api-access

4. Deploy the operator Pod:
Note: Assigning a custom ServiceAccount requires a YAML edit since kubectl run doesn't feature an SA flag.Generate the template first:bash
kubectl run operator --image=nginx:1.21.1 --port=80 -n apps --dry-run=client -o yaml > operator-pod.yaml

# Open operator-pod.yaml and add serviceAccountName: api-access inside the spec block:yaml
apiVersion: v1
kind: Pod
metadata:
  name: operator
  namespace: apps
spec:
  serviceAccountName: api-access # 👈 Add this line
  containers:
  - image: nginx:1.21.1
    name: operator
    ports:
    - containerPort: 80

5. Deploy the disposable Pod:bash
kubectl run disposable --image=nginx:1.21.1 -n rm

6. Open an interactive shell inside the operator pod:bash
kubectl exec -it operator -n apps -- /bin/bash

7. Execute the curl calls from inside the pod's shell:First, set up variables using the pod's internal token directory:bash
TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
CACERT=/var/run/secrets/kubernetes.io/serviceaccount/ca.crt

• Call 1: List Pods in rm namespace:bash
curl --cacert $CACERT -H "Authorization: Bearer $TOKEN" https://default.svc

	• Expected Response: Success (HTTP 200 OK) with a JSON array listing the disposable pod. The api-clusterrole grants full cluster-wide cluster viewing rights for pods.
• Call 2: Attempt to Delete the disposable Pod:bash
curl --cacert $CACERT -X DELETE -H "Authorization: Bearer $TOKEN" https://default.svc
Expected Response: Failure (HTTP 403 Forbidden).