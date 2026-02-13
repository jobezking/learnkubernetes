pods: groups of containers. Can group together container images into single deployable unit. Generally but not always one pod per container
services: provide load balancing, naming, discovery to isolate one microservice from anotehr
namespaces: provide isolation and access control so that each microservice can control the degree which other services interact with it 
ingress: objects provide easy to use frontend that can combine multiple microservices into a single externalized API surface area
cluster components
Kubernetes proxy: responsible for routing network traffic to load-balennced services in k8s cluster. Must be present on every cluster node.
Kubernetes DNS: provides naming and discovery for services defined in cluster. Runs as a replicated service on cluster.
Each Kubernetes object exists at a unique HTTP path; for example, https://your-k8s.com/api/v1/namespaces/default/pods/my-pod
$HOME/.kube/config
Kubernetes UI: 
kubectl
kubectl help
kubectl help <command-name>
kubectl version
kubectl get <resource-name>
kubectl get <resource-name> <obj-name>
kubectl describe <resource-name> <obj-name>
kubectl get nodes
kubectl get pods, services
kubectl explain pods
kubectl describe nodes kube1
kubectl getcomponentstatuses
kubectl get daemonSets --namespace=kube-system kube-proxy
kubectl get deployments --namespace-kube-system core-dns
kubectl get services --namespace-kube-system core-dns
kubectl --namespace=mystuff
kubectl config set-context my-context --namespace=mystuff
kubectl config use-context my-context
kubectl apply -f obj.yaml   #create or update object
kubectl edit <resource-name> <obj-name>
kubectl apply -f obj.yaml view-last-applied
kubectl delete -f obj.yaml
kubectl delete <resource-name> <obj-name> # i.e. kubectl delete pod nginx-pod or kubectl delete deployment hello-world or kubectl delete service sample-service
kubectl label pods bar color=red
kubectl label pods bar color-
kubectl logs <pod-name>
kubectl exec -it <pod-name> -- bash
kubectl attach -it <pod-name>
kubectl cp <pod-name>:</path/to/remote/file> </path/to/local/file>  #copies file from running container to your local machine.
kubectl port-forward <pod-name> 8080:80 # opens up a connection that forwards traffic from the local machine on port 8080 to the remote container on port 80.
You can also use port-forward command with services by specifying services/service-name instead of pod-name but if you port-forward to a service the requests will only 
be forwarded to a single pod in the service. They will not go through the service load balancer
kubectl get events #returns last 10 events of all objects in given namespace
kubectl top nodes
kubectl top pods
kubectl top pods --all-namespaces
kubectl cordon  #prevent future pods from being scheduled on the machine that the command was entered
kubectl drain   #remove any pod currently running on machine
kubectl uncordon    #re-enable pod scheduling
kubectl run kuard --generator=run-pod/v1 --image=gcr.io/kuar-demo/kuard-amd64:blue      # creates pod
kubectl apply -f kuard-pod.yaml
kubectl get pods
kubectl describe pods kuard
kubectl delete pods/kuard
kubectl delete -f kuard-pod.yaml
kubectl logs kuard
kubectl exec kuard -- date
kubectl exec -it kuard -- ash   #get interactive session
kubectl apply -f kuard-pod-health.yaml
kubectl port-forward kuard 8080:8080

Of important note is the distinction between MB/GB/PB and MiB/GiB/PiB. The former is the familiar power of two units (e.g., 1 MB == 1,024 KB) 
while the latter is power of 10 units (1MiB == 1000KiB).
