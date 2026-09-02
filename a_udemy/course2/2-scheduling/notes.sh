kubectl get componentstatuses
kubectl get cs   # see component status
kubectl describe pod nginx | grep -i node  # check the node the pod is running on
kubectl get pods -n kube-system   # see if scheduler pod is running
