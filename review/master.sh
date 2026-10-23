Reference manual: https://kubernetes.io/docs 
Blog: https://kubernetes.io/blog 
Helm: https://helm.sh/docs

$HOME/.kube/config
kubectl config view [--flatten | --minify | --output='json' | --output='yaml']
kubectl get events -o wide
kubectl describe namespace default
kubectl create ns hydra
kubectl get pods -A -o wide
kubectl get pods -l type=front-end
kubectl get pods,svc -n hydra
kubectl delete ns hydra
kubectl get serviceaccount -n kube-system
kubectl config get-contexts
kubectl config set-context my-context --namespace=mystuff  # creates context
kubectl config set-context --current --namespace default
kubectl config use-context my-context  # makes context active
kubectl get pods
kubectl get pods --watch
kubectl explain pods
kubectl explain pods --recursive | more
kubectl explain pods.spec.containers
kubectl explain pods.spec.restartPolicy
kubectl describe pod test
kubectl get pod test -o yaml > test.yaml
kubectl get pod test -o wide
kubectl exec hello-pod -- ps
kubectl exec hello-pod -- ls /tmp
kubectl exec -it test -- sh
apk add curl
env | grep HOSTNAME
exit
kubectl attach -it <pod-name>
kubectl cp nginx:/www/var/html/index.html /home/user/test.html  #copies file from running container to your local machine.
kubectl port-forward <pod-name> 8080:80 # opens up a connection that forwards traffic from the local machine on port 8080 to the remote container on port 80.
kubectl get nodes,pods,services    # no spaces
kubectl get namespaces
kubectl describe nodes kube1
kubectl getcomponentstatuses # kubectl get cs ... this is deprecated
kubectl get daemonSets --namespace=kube-system kube-proxy
kubectl get deployments --namespace-kube-system core-dns
kubectl get services --namespace-kube-system core-dns
kubectl label pods bar color=red  # add label color
kubectl label pods bar color-    # remove label color
kubectl delete pod nginx-pod
kubectl top nodes
kubectl top pods --all-namespaces
kubectl cordon node01 #prevent future pods from being scheduled on the machine that the command was entered
kubectl drain   #remove any pod currently running on machine
kubectl uncordon node01   #re-enable pod scheduling
kubectl logs
kubectl logs hello-pod
kubectl logs deployment/coredns -n kube-system
#
kubectl run webp --image=nginx --port=80 # run pod named web with nginx container and port 80 exposed
kubectl delete pod webp # delete pod named web
kubectl create deployment webd --image=nginx # create deployment named web with nginx image
kubectl scale deployment webd --replicas=3 # scale deployment named web to 3 replicas
kubectl create deployment --image=nginx nginx --dry-run=client -o yaml

kubectl rollout status deployment deployment-name
kubectl rollout history deployment deployment-name
kubectl set image deployment deployment-name container-name=image:tag
kubectl set image deployment webserver nginx=nginx:1.9.1
kubectl rollout undo deployment deployment-name
kubectl rollout undo deployment webserver --to-revision=2

# Three services in Kubernetes are ClusterIP, NodePort, and LoadBalancer.
# ClusterIP: The default service type. It exposes the service on a cluster-internal IP. This means that the service is only accessible from within the cluster.
# NodePort: This service type exposes the service on each node's IP at a static port. 
     # It allows external traffic to access the service by sending requests to <NodeIP>:<NodePort>.
# LoadBalancer: This service type creates an external load balancer that distributes traffic across the nodes
kubectl get services
kubectl get svc <your-service-name>
kubectl describe service service-name
kubectl create service clusterip redis --tcp=6379:6379 --dry-run=client -o yaml
kubectl expose pod nginx --type=NodePort --port=80 --name=nginx-service --dry-run=client -o yaml
kubectl create service nodeport nginx --tcp=80:80 --node-port=30080 --dry-run=client -o yaml

Service ports
# nodePort: port exposed by container inside pod. 
# It is the port that the service will listen on and forward traffic to the targetPort of the pod.
# port: port exposed by service inside cluster. port on the service. Other pods inside the cluster use to talk to this service.
        # It is the port that the service will listen on and forward traffic to the targetPort of the pod.
# targetPort: port exposed by container inside pod. It is the port that the container inside the pod is listening on. 
              # The service forwards traffic from nodePort to targetPort.


Inbound Traffic flow (query)
End User ➔ nodePort ➔ port ➔ targetPort ➔ MySQL Container

Outbound Traffic flow (response)
MySQL Container ➔ targetPort ➔ port ➔ nodePort ➔ End User

# Imperative
kubectl run redis --image=redis:alpine -l tier=backend # create a pod named redis with the redis:alpine image, label tier=backend
kubectl create deployment --image=nginx blue --dry-run=client -o yaml > bluedeployment.yaml
kubectl create deployment webapp --image=kodekloud/webapp-color --replicas=3 # create a deployment named webapp with the kodekloud/webapp-color image and 3 replicas
kubectl expose deployment nginx --port=80 --target-port=80 --type=LoadBalancer  # expose the nginx deployment as a service
kubectl expose pod redis --port=6379 --name=redis-service --type=ClusterIP # expose the redis pod as a service named redis-service of type ClusterIP
kubectl create namespace dev-ns
kubectl create deployment redis-deploy --image=redis --replicas=2 --namespace=dev-ns
kubectl run httpd --image=httpd:alpine
kubectl expose pod httpd --port=80 --name=httpd --type=ClusterIP --port=80
kubectl run httpd --image=httpd:alpine --port=80 --expose  # combines the above two commands into one command
# Node selection # this section will need further study
kubectl get componentstatuses
kubectl get priorityclasses # see all priority classes
kubectl get pods -o custom-columns="NAME:.metadata.name,PRIORITY:.spec.priorityClassName"
kubectl get cs   # see component status
kubectl describe pod nginx | grep -i node  # check the node the pod is running on
kubectl get pods -n kube-system   # see if scheduler pod is running
kubectl replace --force -f pod-definition.yaml  # force replace a pod definition (deletes the pod and creates a new one)
kubectl get pods --selector app=App1 # get pods with label app=App1
kubectl get pods --selector app=App1 --no-headers | wc -l  # count the number of pods with label app=App1

# Taints and tolerations
kubectl run bee --image=nginx --dry-run=client -o yaml # needed to bring up definition file of pod to add toleration
kubectl run bee --image=nginx --dry-run=client -o yaml > bee.yaml  # create a pod definition file
kubectl taint nodes nodename key=value:taint-effect  # taint-effect is what happens to pods that do not tolerate the taint.
#can be NoSchedule, PreferNoSchedule, or NoExecute
kubectl taint nodes node1 app=myapp:NoSchedule  # taint node1 with key=app, value=myapp, effect=NoSchedule
# Taints and tolerations do not direct pods to specific nodes, 
# it tells the node only to accept pods with certain tolerations.
# restricting pods to specific nodes is done with nodeSelector, nodeAffinity, and podAffinity.
# Master node taints are automatically applied to the master node, so that no pods can be scheduled on the master node
kubectl describe node kubemaster | grep -i taint  # check the taints on the master node
kubectl taint nodes <node-name> key=value:effect-  # remove the taint from the node
kubectl taint nodes controlplane node-role.kubernetes.io/control-plane:NoSchedule-   #remove the taint from the controlplane node
kubectl taint nodes <node-name> node-role.kubernetes.io/master- #remove all taints from the node

# Label node for nodeSelector
kubectl label nodes <node-name> <label-key>=<label-value>  # label the node with key=size
kubectl label nodes node01 size=large  # label node01 with key=size and value=large

#Node affinity types
requiredDuringSchedulingIgnoredDuringExecution:  # pod will only be scheduled on nodes that match the affinity rules
preferredDuringSchedulingIgnoredDuringExecution:  # pod will be scheduled on nodes that match the affinity rules if possible, 
                                                   # but if not, it will be scheduled on other nodes
requiredDuringSchedulingRequiredDuringExecution:  # pod will only be scheduled on nodes that match the affinity rules, 
                                                   # and if the node no longer matches the rules, the pod will be evicted
# Node affinity operators
In  # node must have the label with the specified value
NotIn  # node must not have the label with the specified value
Exists  # node must have the label, but the value does not matter 

kubectl get clusterrolebinding

# monitoring
kubectl top node
kubectl top pod

#pod logs
kubectl logs <pod-name>
kubectl logs -f <pod-name>
# If there are multiple containers in a pod:
kubectl logs <pod-name> -c <container-name>
kubectl logs -f <pod-name> <container-name>

#Configmap
#IMPERATIVE
kubectl create configmap <configmap-name> --from-literal=<key>=<value>
kubectl create configmap appconfig --from-literal=APP_COLOR=green --from-literal=APP_MOD=PROD
kubectl create configmap webapp-config-map --from-literal=APP_COLOR=darkblue --from-literal=APP_OTHER=disregard
kubectl create configmap <configmap-name> --from-file=<path-to-file>
kubectl create configmap app-config --from-file=<app_config.properties>
kubectl get configmaps
kubectl describe configmap <configmap-name>

# Secret
echo -n 'mysql.example.com' | base64
kubectl create secret generic <secret-name> --from-literal=<key>=<value>
kubectl create secret generic app-secret --from-literal=DB_HOST=mysql.example.com \
    --from-literal=DB_USER=myuser --from-literal=DB_PASSWORD=mypass
kubectl create secret generic app-secret --from-file=<path-to-file>
kubectl create secret generic app-secret --from-file=app-secrets.properties
kubectl get secrets
kubectl describe secret <secret-name>
kubectl describe secret -o yaml

# Scaling
# manual
kubectl top pods
kubectl top pod my-app
kubectl scale deployment/my-app --replicas=3
# automatic
kubectl autoscale deployment/my-app --min=1 --max=10 --cpu-percent=60  # will create horizontal pod autoscaler (HPA) that polls 
# metrics server for CPU utilization
kubectl delete hpa my-app # deletes the horizontal pod autoscaler

kubectl get networkpolicy
# Authorization/Access commands
cat /etc/kubernetes/manifests/kube-apiserver.yaml
ps -aux | grep authorization
kubectl describe pod kube-apiserver-controlplane -n kube-system
kubectl get roles [--namespace=]
kubectl get rolebindings [--namespace=]
kubectl config view
# Roles and Rolebindings are namespace-scoped. Resources are either namespaced or cluster-scoped
kubectl api-resources --namespaced=true
kubectl api-resources --namespaced=false
kubectl describe role kube-proxy -n kube-system
kubectl get pods --as dev-user
kubernetes create role --help
kubectl create role developer --namespace=default --verb=list,create,delete --resource=pods
kubectl create rolebinding dev-user-binding --namespace=default --role=developer --user=dev-user
kubectl auth can-i create deployments
kubectl auth can-i delete nodes
kubectl auth can-i create deployments --as dev-user
kubectl auth can-i create pods --as dev-user
kubectl auth can-i create pods --as dev-user --namespace test
# clusterroles. Below are examples. Roles are defined.
cluster admin  #view, create, delete nodes
storage admin  #view, create, delete PVs (persistent volumes)
#service accounts
# Every namespace has default service account which is automatically attached to pods on their creation
# service account gets mounted at a projected volume in pod 
kubectl get pods -o yaml | grep serviceAccountName
kubectl get serviceaccount
kubectl describe serviceaccount default       # default k8s svc accnt
kubectl describe pod my-kubernetes-dashboard | grep -i 'Service Account'
kubectl exec -it my-kubernetes-dashboard ls /var/run/secrets/kubernetes.io/serviceaccount
kubectl create serviceaccount dashboard-sa
# to associate service account with a pod, use field serviceAccountName in pod's spec field i.e. spec.serviceAccountName
# if you do not want the token mounted in a pod, you can use the field automountServiceAccountToken: false either in the service
# account definition or the pods spec definition
kubectl create token dashboard-sa --duration 2h # create token whose output can be used in application calls to kubernetes API
# Verify the token is mounted at the expected path:
kubectl exec $(kubectl get pod -l name=web-dashboard -o jsonpath='{.items[0].metadata.name}') -- ls /var/run/secrets/kubernetes.io/serviceaccount/

# Kubernetes volumes
# need to attach volumes to pods for data processed by pod to be preserved when pod is destroyed
# persistent volumes: cluster-wide storage. access modes are ReadOnlyMany, ReadWriteOnce, ReadWriteMany
# persistent volume claim: each PVC is bound to a single PV
kubectl get persistentvolume
kubectl get persistentvolumeclaim
kubectl delete persistentvolumeclaim

kubectl exec podname -- cat filename
kubectl exec webapp -- cat /log/app.log