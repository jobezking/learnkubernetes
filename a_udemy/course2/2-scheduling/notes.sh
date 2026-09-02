kubectl get componentstatuses
kubectl get cs   # see component status
kubectl describe pod nginx | grep -i node  # check the node the pod is running on
kubectl get pods -n kube-system   # see if scheduler pod is running
kubectl replace --force -f pod-definition.yaml  # force replace a pod definition (deletes the pod and creates a new one)
kubectl get pods --selector app=App1 # get pods with label app=App1
kubectl get pods --selector app=App1 --no-headers | wc -l  # count the number of pods with label app=App1