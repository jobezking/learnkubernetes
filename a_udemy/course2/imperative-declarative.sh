# imperative

# Create objects imperatively using kubectl commands. Imperative commands are used to create, update, and delete resources in Kubernetes.
kubectl apply -f pod-definition.yml  # create a pod from a definition file
kubectl run --image=nginx nginx  # create a pod named nginx with the nginx image
kubectl create deployment --image=nginx nginx  # create a deployment named nginx with the nginx image
kubectl expose deployment nginx --port=80 --target-port=80 --type=LoadBalancer  # expose the nginx deployment as a service

#Update objects imperatively using kubectl commands. Imperative commands are used to create, update, and delete resources in Kubernetes.
kubectl apply -f pod-definition.yml  # update a pod from a definition file
kubectl edit deployment nginx  # edit the nginx deployment in place
kubectl scale deployment nginx --replicas=3  # scale the nginx deployment to 3
kubectl set image deployment nginx nginx=nginx:1.19  # update the nginx deployment to use the nginx:1.19 image
kubectl delete deployment nginx  # delete the
