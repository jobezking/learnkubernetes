kubectl get pods -n kube-system  # shows kubernetes system pods
kubectl run nginx --image=nginx
kubectl scale replicaset myapp-replicaset --replicas=5
kubectl scale rs myapp-replicaset --replicas=5
kubectl scale --replicas=5 -f replicaset-definition.yml
kubectl delete rs myapp-replicaset
kubectl replace -f replicaset-definition.yml
#Deployments automatically create ReplicaSets with the name of the deployment and create pods including the name of the deployment