# How to enable metrics server for Kubernetes logging and monitoring (below is not for production)
git clone https://github.com/kubernetes-sigs/metrics-server.git
kubectl create -f metrics-server/deploy/1.8+/
#or
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
#to monitor:
kubectl top node
kubectl top pod

#pod logs
kubectl logs <pod-name>
kubectl logs -f <pod-name>
# If there are multiple containers in a pod:
kubectl logs <pod-name> -c <container-name>
kubectl logs -f <pod-name> <container-name>