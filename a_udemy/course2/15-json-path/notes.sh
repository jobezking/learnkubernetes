# JSON Path in Kubectl
1. identify the kubectl command i.e. kubectl get nodes, kubectl get pods
2. learn json output of command i.e. kubectl get nodes -o json; kubectl get pods -o json
3. Form JSON Path query
4. use the JSON Path query with kubectl command
kubectl get nodes -o=jsonpath='{.items[*].metadata.name}'
kubectl get nodes -o=jsonpath='{.items[*].status.nodeInfo.architecture}'
kubectl get nodes -o=jsonpath='{.items[*].status.capacity.cpu}'
#combine
kubectl get nodes -o=jsonpath='{.items[*].metadata.name}{.items[*].status.capacity.cpu}'
kubectl get nodes -o=jsonpath='{.items[*].metadata.name}{"\n"}{.items[*].status.capacity.cpu}'

###
FOR EACH NODE                                       '{range.items[*]}   
    PRINT NODE NAME \t PRINT CPU COUNT \n               {.metadata.name} {"\t"}{.status.capacity.cpu} {"\n"}
END FOR                                               {end}'
###
kubectl get nodes -o=jsonpath='{range.items[*]} {.metadata.name} {"\t"}{.status.capacity.cpu} {"\n"} {end}'
kubectl get nodes -o=custom-columns=<COLUMN NAME>:<JSON PATH>
kubectl get nodes -o=custom-columns=NODE:.metadata.name,CPU:.status.capacity.cpu
kubectl get nodes --sort-by=.metadata.name
kubectl get nodes --sort-by=.status.capacity.cpu

kubectl get nodes -o json > nodes.json
'{.items[*].metadata.name}'