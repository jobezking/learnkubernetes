kubectl drain <node-name> --ignore-daemonsets --delete-local-data # do before taking down node for maintenance
# pods are recreated on another node and node is marked as unschedulable
kubectl uncordon <node-name> # do after maintenance is complete to allow scheduling of pods on the node again
kubectl cordon <node-name> # mark node as unschedulable to prevent scheduling of pods on the node
kubectl get pods -o wide # check where pods are running

# Upgrade k8s one minor version at a time, e.g. 1.25.x -> 1.26.x -> 1.27.x
# First upgrade master node then upgrade worker nodes
kubeadm upgrade plan # check for available upgrades