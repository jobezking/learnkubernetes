# Kubernetes primitive structure:
API Version: defines structure of the primitive
Kind: defines the type of primitive i.e. pod, service etc.
Metadata: higher level info about object
Spec: specification. The desired state after object has been created
Status: the actual state of the object

kubectl explain: time-saving tool during exam i.e.
kubectl explain pods.spec.containers
kubectl explain deployment.spec.strategy.rollingUpdate

kubectl run frontend --image=nginx:1.29.0 --port=80
kubectl edit pod frontend
kubectl patch pod frontend -p '{"spec":{"containers":[{"name":"frontend",\
"image":"nginx:1.29.2"}]}}'
kubectl delete pod frontend
kubectl delete pod frontend --now

kubectl get pod web-app -o yaml

kubectl apply -f nginx-deployment.yaml
kubectl get deployment nginx-deployment -o yaml
kubectl delete -f nginx-deployment.yaml

# kubectl run options: --image; --port; --env; --rm; --dry-run=client; -o yaml
#Pod lifecycle: Pending -> Running -> Succeeded/Failed
# Pending: Pod has been accepted by the Kubernetes system, but one or more of the container images has not been created. This includes time before being scheduled as well as time spent downloading images over the network, which could take a while.
# Running: The Pod has been bound to a node, and all of the containers have been created. At least one container is still running, or is in the process of starting or restarting.
# Succeeded: All containers in the Pod have terminated in success, and will not be restarted.
# Failed: All containers in the Pod have terminated, and at least one container has terminated in failure. That is, the container either exited with non-zero status or was terminated by the system.
# Unkown: For some reason the state of the Pod could not be obtained, typically due to an error in communicating with the host of the Pod.
# Container level restart policy: Always, OnFailure, Never

kubectl run frontend --image=nginx:1.29.2 --port=80 -o yaml --dry-run=client > pod.yaml
vim pod.yaml
kubectl apply -f pod.yaml

kubectl describe pods hazelcast
kubectl logs hazelcast
kubectl exec -it hazelcast -- /bin/sh
kubectl delete pod hazelcast --grace-period=0 --force

# To send a single command
kubectl exec hazelcast -- ls /opt/hazelcast
# create temporary pod to run a command in the cluster
kubectl run -i --tty temp-pod --image=busybox --rm -it --restart=Never -- ls /opt
# namespaces
kubectl get namespaces
kubectl create namespace my-namespace
kubectl get namespace my-namespace -o yaml > my-namespace.yaml
kubectl run pod --image=nginx:1.25.1 -n my-namespace
kubectl get pods -n my-namespace
kubectl delete namespace my-namespace  # will automatically delete pods and other objects inside namespace

sudo kubeadm init --pod-network-cidr=10.244.0.0/16

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f [podnetwork].yaml https://kubernetes.io/docs/concepts/cluster-administration/addons/
kubeadm token create --print-join-command

kubectl create ns kube-flannel
kubectl label --overwrite ns kube-flannel pod-security.kubernetes.io/ enforce=privileged
helm repo add flannel https://flannel-io.github.io/flannel/
helm install flannel --set podCidr="10.244.0.0/16" --namespace kube-flannel flannel/flannel

# Upgrading
# start with control plane
sudo apt update
sudo apt-cache madison kubeadm
sudo apt-mark unhold kubeadm && sudo apt-get update && sudo apt-get install \
  -y kubeadm=1.31.5-1.1 && sudo apt-mark hold kubeadm
sudo apt-get update && sudo apt-get install -y --allow-change-held-packages \
  kubeadm=1.31.5-1.1
kubeadmn version
sudo kubeadm upgrade plan
sudo kubeadm upgrade apply v1.31.5

kubectl drain kube-control-plane --ignore-daemonsets
sudo apt-mark unhold kubelet kubectl && sudo apt-get update && sudo \
  apt-get install -y kubelet=1.31.5-1.1 kubectl=1.31.5-1.1 && sudo apt-mark \
  hold kubelet kubectl
sudo systemctl daemon-reload
sudo systemctl restart kubelet
kubectl uncordon kube-control-plane
kubectl get nodes
#now workers
sudo apt-mark unhold kubeadm && sudo apt-get update && sudo apt-get install \
  -y kubeadm=1.31.5-1.1 && sudo apt-mark hold kubeadm
kubeadm version
sudo kubeadm upgrade node
kubectl drain kube-worker-1 --ignore-daemonsets
sudo apt-mark unhold kubelet kubectl && sudo apt-get update && sudo apt-get \
  install -y kubelet=1.31.5-1.1 kubectl=1.31.5-1.1 && sudo apt-mark hold kubelet \
  kubectl
sudo systemctl daemon-reload
sudo systemctl restart kubelet
kubectl uncordon kube-worker-1
kubectl get nodes

# etcd backup/restore
#to install etcdctl and etcdutl
sudo apt update && sudo apt install -y etcd-client && echo 'export ETCDCTL_API=3' >> ~/.bashrc

sudo ETCDCTL_API=3 etcdctl --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key \
  snapshot save /opt/etcd-backup.db

sudo ETCDCTL_API=3 etcdctl snapshot restore /opt/etcd-backup.db \
  --data-dir=/var/lib/etcd-backup

# OR

sudo ETCDCTL_API=3 etcdutl --data-dir=/var/lib/from-backup snapshot restore \
  /opt/etcd-backup.db

# Authentication and authorization
$HOME/.kube/config # contains the credentials for the cluster used by kubectl to authenticate to the cluster. 
# contains information about the cluster, user, and context.
kubectl config view # view the contents of the kubeconfig file
kubectl config get-contexts; kubectl config current-context # list all contexts in the kubeconfig file
kubectl config use-context <context-name> # switch to a different context
kubectl config set-credentials myuser \
  --client-key=myuser.key --client-certificate=myuser.crt \
  --embed-certs=true # set credentials for a user in the kubeconfig file
# role: API primitives that define a set of permissions for a user or group of users. Roles can be created at the namespace level or cluster level.
# default roles: cluster-admin, admin, edit, view
# rolebinding: API primitive that binds a role to a user or group of users. RoleBindings can be created at the namespace level or cluster level.
kubectl create role read-only --verb=get,list,watch --resource=pods --namespace=default # create a role that allows read-only access to pods in the default names
kubectl create rolebinding alice-pod-reader --role=pod-reader --user=alice #create a role binding that binds the pod-reader role to a user named alice in the default namespace
kubectl create rolebinding read-only-binding --role=read-only --user=bmuschko
kubectl get rolebindings
kubectl get roles 
kubectl describe rolebinding read-only-binding # create a role binding that binds the read-only role to a user
kubectl auth can-i --list --as bmuschko # check what actions a user can perform in the cluster
# Service accounts: API primitive that provides an identity for processes that run in a pod. Service accounts can be used to authenticate to the Kubernetes API server and access resources in the cluster.
kubectl create serviceaccount my-service-account # create a service account named my-service-account in the default namespace
kubectl get serviceaccounts # list all service accounts in the default namespace
kubectl describe serviceaccount my-service-account # view details of a service account
# assigning service account to a pod cannot be done imperatively requires declarative approach (yaml file)

# CRD: Custom Resource Definition is an API primitive that allows users to define their own custom resources in Kubernetes. CRDs can be used to extend the Kubernetes API with new resource types that are not included in the default Kubernetes API.
# Installing operator lifetime manager
curl -sL https://github.com/operator-framework/operator-lifecycle-manager/releases/download/v0.31.0/install.sh | bash -s v0.31.0
kubectl create -f https://operatorhub.io/install/argocd-operator.yaml
kubectl get csv -n openshift-operators
kubectl get csv -n operators
# Application:  group of kubernetes resources as defined by a manifest
# ApplicationSet: a group or set of Application resources
# App Project: logical grouping that defines which git repos, clusters, namespaces a set of applications can access. Multitenancy and security boundaries
kubectl get crds
kubectl describe crd applications.argoproj.io
# nginx-application.yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: nginx
spec:
  project: default
  source:
    repoURL: https://github.com/bmuschko/cka-study-guide.git
    targetRevision: HEAD
    path: ./ch07/nginx
  destination:
    server: https://kubernetes.default.svc
    namespace: default
#  kubectl apply -f nginx-application.yaml
kubectl describe application nginx
kubectl delete application nginx
kubectl get deployments,services,pods -l app=nginx
kubectl get deployments,pods -n operators

# Helm
helm repo list
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add jenkins https://charts.jenkins.io
helm repo update
helm search repo bitnami
helm install my-jenkins jenkins/jenkins --version 5.8.25 --set controller.adminPassword=admin123
kubectl get pods -n default -l app.kubernetes.io/instance=my-jenkins
helm show jenkins/jenkins
helm show values jenkins/jenkins
helm install my-jenkins jenkinsci/jenkins --version 4.6.4 --set controller.adminUser=boss --set controller.adminPassword=password \
-n jenkins --create-namespace
helm list -n
helm repo update
helm upgrade my-jenkins jenkinsci/jenkins --version 5.8.26
helm uninstall my-jenkins -n jenkins
# kustomize: tool for customizing kubernetes resource configuration. It allows you to define a base set of resources and then apply overlays to modify those resources for different environments or use cases.
kubectl kustomize <target>
kubectl apply -k <target>

# configmap: API primitive that allows you to store configuration data as key-value pairs. 
# ConfigMaps can be used to decouple configuration data from application code and provide a way to manage configuration data in a centralized manner.
kubectl configmap create my-config --from-literal=key1=value1 --from-literal=key2=value2
kubectl configmap create my-config --from-file=config.txt
kubectl configmap create my-config --from-file=config-dir/
kubectl configmap create my-config --from-env-file=config.env
#
apiVersion: v1
kind: ConfigMap
metadata:
  name: db-config
data:
  DB_HOST: mysql-service
  DB_USER: backend
#
apiVersion: v1
kind: Pod
metadata:
  name: backend
spec:
  containers:
  - image: bmuschko/web-app:1.0.1
    name: backend
    envFrom:
    - configMapRef:
        name: db-config
#
kubectl exec backend -- env
#
apiVersion: v1
kind: Pod
metadata:
  name: backend
spec:
  containers:
  - image: bmuschko/web-app:1.0.1
    name: backend
    volumeMounts:
    - name: db-config-volume
      mountPath: /etc/config
  volumes:
  - name: db-config-volume
    configMap:                             
      name: db-config
#
#Secrets
kubectl secret create my-secret --from-literal=username=admin --from-literal=password=secret123
kubectl secret create my-secret --from-file=ssh-privatekey
kubectl secret create my-secret --from-file=ssh-publickey
kubectl secret create my-secret --from-env-file=secrets.env

# Deployments
kubectl create deployment app-cache --image=memcached:1.6.8
#Labels
metadata.labels 
spec.selector.matchLabels 
spec.template.metadata.labels
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-cache
  labels:
    app: app-cache
spec:
  replicas: 4
  selector:
    matchLabels:
      app: app-cache
  template:
    metadata:
      labels:
        app: app-cache
    spec:
      containers:
      - name: app-cache
        image: memcached:1.6.8
#
kubectl get deployments -o wide
kubectl get replicasets, pods -l app=app-cache
kubectl edit deployment app-cache
kubectl describe deployment app-cache
kubectl scale deployment app-cache --replicas=6
kubectl set image deployment app-cache app-cache=memcached:1.6.9
kubectl rollout status deployment app-cache
kubectl rollout history deployment app-cache
kubectl rollout history deployment app-cache --revision=1
kubectl rollout history deployment app-cache --revision=2
kubectl rollout undo deployment app-cache
kubectl rollout undo deployment app-cache --to-revision=1
kubectl delete deployment app-cache
#HPA: requres metrics server. Also requires spec.containers[].requests.cpu to be set in pods for CPU-based scaling. HPA can also scale based on memory usage or custom metrics.
kubectl autoscale deployment app-cache --cpu-percent=80 --min=3
#
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: app-cache
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: app-cache
  minReplicas: 3
  maxReplicas: 5
  metrics:
  - resource:
      name: cpu
      target:
        averageUtilization: 80
        type: Utilization
    type: Resource
#
kubectl get hpa
kubectl describe hpa app-cache
#mutiple scaling metrics
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: app-cache
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: app-cache
  minReplicas: 3
  maxReplicas: 5
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 80
  - type: Resource
    resource:
      name: memory
      target:
        type: AverageValue
        averageValue: 500Mi
# Container resource requests and limits
spec.containers[].resources.requests.cpu                CPU resource type                     500m (five hundred millicpu) 
spec.containers[].resources.requests.memory             Memory resource type                  64Mi (2^26 bytes) 
spec.containers[].resources.requests.hugepages-<size>   Huge page resource type               hugepages-2Mi: 60Mi
spec.containers[].resources.requests.ephemeral-storage  Ephemeral storage resource type       4Gi
#
apiVersion: v1
kind: Pod
metadata:
  name: rate-limiter
spec:
  containers:
  - name: business-app
    image: bmuschko/nodejs-business-app:1.0.0
    ports:
    - containerPort: 8080
    resources:
      requests:
        memory: "256Mi"
        cpu: "1"
      limits:
        memory: "256Mi"
  - name: ambassador
    image: bmuschko/nodejs-ambassador:1.0.0
    ports:
    - containerPort: 8081
    resources:
      requests:
        memory: "64Mi"
        cpu: "250m"
      limits:
        memory: "64Mi"
# Best practices for resource requests and limits:
Always define memory requests. Always define memory limits. 
Always set your memory requests equal to your limit. 
Always define CPU requests. Do not use CPU limits.
# Resource quotas: API primitive that allows you to limit the amount of resources that can be consumed by a namespace. Resource quotas can be used to prevent a single namespace from consuming all the resources in a cluster and to ensure fair resource allocation among different namespaces.
1. Create namespace
kubectl create namespace team-awesome
2. Create resource quota
apiVersion: v1
kind: ResourceQuota
metadata:
  name: team-awesome-quota
  namespace: team-awesome
spec:
  hard:
    requests.cpu: "4"
    requests.memory: 8Gi
    limits.cpu: "8"
    limits.memory: 16Gi
3. Apply resource quota
kubectl apply -f team-awesome-quota.yaml
kubectl describe resourcequota awesome-quota -n team-awesome
# Limit ranges: API primitive that allows you to define minimum and maximum resource limits for a namespace. Limit ranges can be used to enforce resource usage policies and to ensure that pods in a namespace do not exceed certain resource limits.
apiVersion: v1
kind: LimitRange
metadata:
  name: team-awesome-limits
  namespace: team-awesome
spec:
  limits:
  - type: Container
    max:
      cpu: "2"
      memory: 4Gi
    min:
      cpu: "100m"
      memory: 128Mi
kubectl apply -f team-awesome-limits.yaml
kubectl describe limitrange team-awesome-limits -n team-awesome   
# scheduling pods. Look for scheduler, which should be kube-scheduler*
kubectl get pods -n kube-system
# find nodes that a pod runs on
kubectl get pod nginx -o=wide
kubectl get pod nginx -o yaml | grep nododeName:
kubectl  describe pod nginx | grep Node:
# node selector: label node and define pod to match label
kubectl label node node01 disk=ssd
kubectl get nodes --show-labels
#
apiVersion: v1
kind: Pod
metadata:
  name: app
spec:
  nodeSelector:
    disk: ssd
  containers:
  - name: nginx
    image: nginx:1.27.1
#
kubectl get node node02 -o yaml | grep -C 3 taints:
kubectl taint node node02 special=true:NoSchedule
# add toleration to pod so it will run on tainted node. Example shows matching toleration assigned to pod for taint special=true:NoSchdule
apiVersion: v1
kind: Pod
metadata:
  name: app
spec:
  tolerations:
  - key: "special"
    operator: "Equal"
    value: "true"
    effect: "NoSchedule"
  containers:
  - name: nginx
    image: nginx:1.27.1
# Volumes
# Relevant to exam: hostPath, emptyDir, configMap, secret, persistentVolumeClaim, nfs 
apiVersion: v1
kind: Pod
metadata:
  name: business-app
spec:
  volumes:
  - name: shared-data
    emptyDir: {}                            
  containers:
  - name: nginx
    image: nginx:1.27.1
    volumeMounts:
    - name: shared-data
      mountPath: /usr/share/nginx/html
      readOnly: false   
  - name: sidecar
    image: busybox:1.37.0
    volumeMounts:
    - name: shared-data
      mountPath: /data
#
kubectl get pod business-app -o yaml | grep -C 3 volumes:
kubectl exec business-app -it -c nginx --
# Persistent Volumes
# Types: hostPath (testing only), local (requires node affinity), nfs, csi (container storage interface; most common), fc, icsci
# modes: filesystem, block
apiVersion: v1
kind: PersistentVolume
metadata:
  name: db-pv
spec:
  capacity:                   
    storage: 1Gi         
  accessModes:           
    - ReadWriteOnce      
  hostPath:
    path: /data/db
#
kubectl get pv db-pv -o yaml | grep -C 3 capacity:
kubectl get pv -o wide
# Access Modes: ReadWriteOnce (RWO), ReadOnlyMany (ROX), ReadWriteMany (RWX), ReadWriteOncePod (RWOP)
kubectl get pv db-pv -o jsonpath='{.spec.accessModes}'
# Reclaim policies: Retain, Recycle, Delete
kubectl get pv db-pv -o jsonpath='{.spec.persistentVolumeReclaimPolicy}'
# node affinity definition
apiVersion: v1
kind: PersistentVolume
metadata:
  name: local-pv
spec:
  capacity:
    storage: 10Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: local-storage
  local:                                               
  path: /mnt/data
  nodeAffinity:                                   
    required:
      nodeSelectorTerms:
      - matchExpressions:
        - key: kubernetes.io/hostname             
          operator: In
          values:
          - node01
          - node02
# Define a PVC
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: db-pvc
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: local-storage
  resources:
    requests:
      storage: 1Gi
#
kubectl gget pvc db-pvc
kubectl describe pvc db-pvc
# Binding pv to pvc: static (pv created first) or dynamic (pvc created first) by name
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: specific-pvc
spec:
  volumeName: db-pv           
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
# mounting a PVC in a pod
apiVersion: v1
kind: Pod
metadata:
  name: db-app
spec:
  containers:
  - name: db-app
    image: bmuschko/postgres:1.0.0
    volumeMounts:
    - name: db-storage    
      mountPath: /var/lib/postgresql/data
  volumes:
  - name: db-storage
    persistentVolumeClaim:
      claimName: db-pvc
# 
kubectl get pods
kubectl describe pod app-cache
kubectl describe pvc specific-pvc
# Storage Classes: API primitive that allows you to define different types of storage in a Kubernetes cluster. Storage classes can be used to define different performance characteristics, availability, and cost for different types of storage.
kubectl get storageclass
#
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: fast
provisioner: kubernetes.io/gce-pd
parameters:
  type: pd-ssd
  replication-type: regional-pd
#
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: db-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 512Mi
  storageClassName: standard
#
kubectl get pv,pvc -o wide
#Services
#Access Scopes
# LoadBalancer: accessible outside k8s cluster using external load balancer. 
# NodePort: accessible outside k8s cluster using node ip and port. Exposes the Service on each node’s IP address at a static port. Accessible from outside of the cluster. The Service type does not provide any load balancing across multiple nodes.
# ClusterIP: accessible only inside k8s cluster. Exposes the Service on a cluster-internal IP. Reachable only from within the cluster. Kubernetes uses a round-robin algorithm to distribute traffic evenly among the targeted Pods.
#Quickly create pod and service using kubectl run (imperative approach)
kubectl run echoserver --image=k8s.gcr.io/echoserver:1.10 --restart= Never --port=8080
kubectl create service clusterip echoserver --tcp=8080:8080
# combine the two
kubectl run echoserver --image=k8s.gcr.io/echoserver:1.10 --restart=Never --port=8080 --expose
# Deployment with service
kubectl create deployment echoserver --image=hashicorp/http-echo:1.0.0 --replicas=5
kubectl expose deployment echoserver --port=80 --target-port=8080
kubectl get svc echoserver -o yaml
kubectl get endpoints echoserver -o yaml
kubectl get pods -l app=echoserver
kubectl describe svc echoserver
kubectl get endpointslices -l app=echoserver
kubectl describe endpointslice echoserver-xxxxx
#ClusterIP
kubectl run echoserver --image=k8s.gcr.io/echoserver:1.10 --restart=Never --port=8080 -l app=echoserver
kubectl create service clusterip echoserver --tcp=5005:8080
wget 10.96.254.0:5005 --timeout=5  --tries=2 # access service using ClusterIP from inside the cluster
kubectl run tmp --image=busybox:1.36.1 --restart=Never -it --rm -- wget 10.96.254.0:5005 # access service using ClusterIP from inside the cluster
kubectl run tmp --image=busybox:1.36.1 --restart=Never -it --rm -n other -- wget echoserver.default.svc.cluster.local:5005 
# access service using DNS from inside the cluster in different namespace
kubectl exec -it echoserver -- env # service environment variables are automatically injected into the pod by kubernetes
#NodePort
kubectl run echoserver --image-k8s.gcr.io/echoserver:1.10 --restart=Never --port=8080 -l app=echoserver
kubectl create service nodeport echoserver --tcp=5005:8080
kubectl get svc echoserver -o yaml      # presume it gives 5005:30158 as ports. 30158 is the node port. 5005 is the target port. 8080 is the container port.
kubectl get endpoints echoserver -o yaml  
kubectl run tmp --image=busybox:1.36.1 --restart=Never -it --rm -- wget 10.96.254.0:5005 # access service using ClusterIP from inside the cluster
kubectl get nodes -o jsonpath='{ $.items[*].status.addresses[?(@.type=="InternalIP")].address}' # get node IP address
wget <node-ip>:30158 --timeout=5  --tries=2 # access service using NodePort from outside the cluster
# Load Balancer (only for cloud)
kubectl run echoserver --image=k8s.gcr.io/echoserver:1.10 --restart=Never --port=8080 -l app=echoserver
kubectl create service loadbalancer echoserver --tcp=5005:8080
kubectl get svc echoserver -o yaml     
# gives CLUSTER-IP, EXTERNAL-IP, PORT(S) 5005:30158/TCP
wget <external-ip>:5005 --timeout=5  --tries=2 # access service using LoadBalancer from outside the cluster
# Ingress
kubectl get pods -n ingress-nginx
kubectl get ingressclasses
Ingress rules: host, path, backend service, backend service port
kubectl create ingress next-app \
  --rule="next.example.com/app=app-service:8080" \
  --rule="next.example.com/metrics=metrics-service:9090"
# path types: exact, prefix, implementationSpecific
kubectl get ingress
kubectl get ingress next-app -o yaml
kubectl describe ingress next-app
kubectl run app --image=k8s.gcr.io/echoserver:1.10 --port=8080 -l app=app-service
kubectl run metrics --image=k8s.gcr.io/echoserver:1.10 --port=8080 -l app=metrics-service
kubectl create service clusterip app-service --tcp=8080:8080
kubectl create service clusterip metrics-service --tcp=9090:8080
kubectl get ingress next-app --output=jsonpath="{.status.loadBalancer.ingress[0]['ip']}"
wget next.example.com/app --timeout=5 --tries=2