kubectl get componentstatuses
kubectl get cs   # see component status
kubectl describe pod nginx | grep -i node  # check the node the pod is running on
kubectl get pods -n kube-system   # see if scheduler pod is running
kubectl replace --force -f pod-definition.yaml  # force replace a pod definition (deletes the pod and creates a new one)
kubectl get pods --selector app=App1 # get pods with label app=App1
kubectl get pods --selector app=App1 --no-headers | wc -l  # count the number of pods with label app=App1
# Taints and tolerations
kubectl taint nodes nodename key=value:taint-effect  # taint-effect is what happens to pods that do not tolerate the taint.
#can be NoSchedule, PreferNoSchedule, or NoExecute
kubectl taint nodes node1 app=myapp:NoSchedule  # taint node1 with key=app, value=myapp, effect=NoSchedule
# Taints and tolerations do not direct pods to specific nodes, 
# it tells the node only to accept pods with certain tolerations.
# restricting pods to specific nodes is done with nodeSelector, nodeAffinity, and podAffinity.
# Master node taints are automatically applied to the master node, so that no pods can be scheduled on the master node
kubectl describe node kubemaster | grep -i taint  # check the taints on the master node