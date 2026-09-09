kubectl drain <node-name> --ignore-daemonsets --delete-local-data # do before taking down node for maintenance
# pods are recreated on another node and node is marked as unschedulable
kubectl uncordon <node-name> # do after maintenance is complete to allow scheduling of pods on the node again
kubectl cordon <node-name> # mark node as unschedulable to prevent scheduling of pods on the node