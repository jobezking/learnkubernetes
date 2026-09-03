kubectl get componentstatuses
kubectl get cs   # see component status
kubectl describe pod nginx | grep -i node  # check the node the pod is running on
kubectl get pods -n kube-system   # see if scheduler pod is running
kubectl replace --force -f pod-definition.yaml  # force replace a pod definition (deletes the pod and creates a new one)
kubectl get pods --selector app=App1 # get pods with label app=App1
kubectl get pods --selector app=App1 --no-headers | wc -l  # count the number of pods with label app=App1
kubectl get pods -o wide  # get pods with more details including nodes they are on
# Taints and tolerations
kubectl run bee --image=nginx --dry-run=client -o yaml # needed to bring up definition file of pod to add toleration
kubectl run bee --image=nginx --dry-run=client -o yaml > bee.yaml  # create a pod definition file
kubectl taint nodes nodename key=value:taint-effect  # taint-effect is what happens to pods that do not tolerate the taint.
#can be NoSchedule, PreferNoSchedule, or NoExecute
kubectl taint nodes node1 app=myapp:NoSchedule  # taint node1 with key=app, value=myapp, effect=NoSchedule
# Taints and tolerations do not direct pods to specific nodes, 
# it tells the node only to accept pods with certain tolerations.
# restricting pods to specific nodes is done with nodeSelector, nodeAffinity, and podAffinity.
# Master node taints are automatically applied to the master node, so that no pods can be scheduled on the master node
kubectl describe node kubemaster | grep -i taint  # check the taints on the master node
kubectl taint nodes <node-name> key=value:effect-  # remove the taint from the node
kubectl taint nodes controlplane node-role.kubernetes.io/control-plane:NoSchedule-   #remove the taint from the controlplane node
kubectl taint nodes <node-name> node-role.kubernetes.io/master- #remove all taints from the node