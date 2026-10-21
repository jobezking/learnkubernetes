$HOME/.kube/config
kubectl config view [--flatten | --minify | --output='json' | --output='yaml']
kubectl get events -o wide
kubectl describe namespace default
kubectl create ns hydra
kubectl get pods -l type=front-end
kubectl get pods,svc -n hydra
kubectl delete ns hydra
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
kubectl get nodes, pods, services
kubectl get namespaces
kubectl describe nodes kube1
kubectl getcomponentstatuses
kubectl get daemonSets --namespace=kube-system kube-proxy
kubectl get deployments --namespace-kube-system core-dns
kubectl get services --namespace-kube-system core-dns
kubectl label pods bar color=red  # add label color
kubectl label pods bar color-    # remove label color
kubectl delete pod nginx-pod
kubectl top nodes
kubectl top pods --all-namespaces
kubectl cordon  #prevent future pods from being scheduled on the machine that the command was entered
kubectl drain   #remove any pod currently running on machine
kubectl uncordon    #re-enable pod scheduling
kubectl logs
kubectl logs hello-pod
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