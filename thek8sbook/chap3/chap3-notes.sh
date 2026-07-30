nodes: host servers (physical, virtual or cloud) that run the Kubernetes worker processes and host the pods. Each node contains the services necessary to run pods, 
including the container runtime, kubelet, and kube-proxy.
pods: wrap containers and execute on nodes. Is the smallest deployable k8s unit
nodeSelectors
affinity and anti-affinity
Topology spread constraints
Resource requests and resource limits
rules are for scheduling pods to nodes. They can be hard or soft, and can be affinity or anti-affinity.
affinity rules: attract pods to nodes based on labels and other criteria
anti-affinity rules: repel pods from nodes based on labels and other criteria
hard rules: must be satisfied for scheduling to occur
soft rules: preferred but not required for scheduling to occur
9 Step Process to Deploy a Pod
1. Definte pod in yaml manifest file
2. Post the manifest to the API server using kubectl apply -f <manifest.yaml>
3. The request is authenticated and authorized by the API server
4. The pod specification is validated by the API server
5. The scheduler filters nodes based on nodeSelectors, affinity and anti-affinity rules, topology spread constraints, and resource requests and limits etc.
6. The pod is assigned to a healthy node meeting all requirements
7. The kubelet on the node watches API server and notices the pod assignment
8. The kubelet downloads the pod specification and asks local container runtime to start it
9. The kubelet monitors the pod and reports status back to the API server
resource requests: minimum amount of CPU and memory resources that a pod requires to run. The scheduler uses this information to determine which nodes have enough available resources to accommodate the pod.
resource limits: maximum amount of CPU and memory resources that a pod can use. The container runtime enforces these limits.
kubectl get nodes
cat /home/[username]/.kube/config
kubectl config view [--flatten | --minify | --output='json' | --output='yaml']
kubectl config current-context
kubectl config get-contexts
kubectl get pods
kubectl get pods --watch
kubectl explain pods --recursive | more
kubectl explain pods.spec.containers
kubectl explain pods.spec.restartPolicy
kubectl apply -f pod.yaml
kubectl get pods hello-pod -o yaml
kubectl describe pod hello-pod
kubectl logs
kubectl logs hello-pod
kubectl logtest --container syncer

kubectl exec hello-pod -- ps
kubectl exec hello-pod -- ls /tmp
kubectl exec -it hello-pod -- sh
apk add curl
env | grep HOSTNAME
exit

kubectl edit pod hello-pod
kubectl delete pod hello-pod initpod
kubectl delete svc k8sbook svc-sidecar
kubectl delete -f pod.yaml
kubectl delete -f pod.yaml initpod.yaml

kubectl api-resources
kubectl get namespaces
kubectl describe namespace default # kubectl describe ns default
kubectl get svc --namespace kube-system
kubectl get pods --namespace kube-system
kubectl create ns hydra  # kubectl create namespace hydra 
kubectl apply -f shield-namespace.yml
kubectl get ns
kubectl config set-context --current --namespace hydra
kubectl get pods -n hydra
kubectl get svc -n hydra
kubectl delete ns hydra
kubectl config set-context --current --namespace default