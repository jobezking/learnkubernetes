# chapter 3
#Create a Pod named nginx that uses the container image nginx:1.27.4-alpine.
kubectl run nginx --image=nginx:1.27.4-alpine
# Identify the node the Pod has been scheduled on.
kubectl get pod nginx -o wide
# Evict all Pods from the node that runs the Pod at once
kubectl drain --ignore-daemonsets node01-e --force