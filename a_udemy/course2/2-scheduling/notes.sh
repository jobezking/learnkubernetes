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

# Label node for nodeSelector
kubectl label nodes <node-name> <label-key>=<label-value>  # label the node with key=size
kubectl label nodes node01 size=large  # label node01 with key=size and value=large

#Node affinity types
requiredDuringSchedulingIgnoredDuringExecution:  # pod will only be scheduled on nodes that match the affinity rules
preferredDuringSchedulingIgnoredDuringExecution:  # pod will be scheduled on nodes that match the affinity rules if possible, 
                                                   # but if not, it will be scheduled on other nodes
requiredDuringSchedulingRequiredDuringExecution:  # pod will only be scheduled on nodes that match the affinity rules, 
                                                   # and if the node no longer matches the rules, the pod will be evicted
# Node affinity operators
In  # node must have the label with the specified value
NotIn  # node must not have the label with the specified value
Exists  # node must have the label, but the value does not matter   


# DaemonSets runs one copy of the pod on each node in the cluster. When a new node is added to the cluster, a copy of the pod is 
# automatically scheduled on that node. When a node is removed the pod is removed. Ensures that a copy of the pod is running on all nodes in the cluster.