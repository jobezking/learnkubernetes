kubectl get pods -n kube-system  # shows kubernetes system pods
kubectl run nginx --image=nginx
kubectl scale replicaset myapp-replicaset --replicas=5
kubectl scale rs myapp-replicaset --replicas=5
kubectl scale --replicas=5 -f replicaset-definition.yml