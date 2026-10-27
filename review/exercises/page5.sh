# chapter 17
# service selects pod with matching label. Pod exposes app on container port 8080 with label run=echoserver
kubectl run echoserver --image=nginx --port=8080
# create service. types: ClusterIP, NodePort, LoadBalancer
kubectl create service clusterip echoserver --tcp=80:8080
# create deployment and service
kubectl create deployment echoserverd --image=nginx --replicas=5
kubectl expose deployment echoserver --port=80 --target-port=8080
#
kubectl get endpointslices -l app=echoserver
kubectl describe endpointslice echoserver-js2xj
kubectl create service clusterip echoserver --tcp=5005:8080 --dry-run=client -o yaml > clusterip.yml
kubectl get svc echoserver #(use cluster-ip in wget)
kubectl run tmp --image=busybox:1.36.1 --restart=Never -it --rm -- wget 10.96.254.0:5005
kubectl run tmp --image=busybox:1.36.1 --restart=Never -it --rm -- wget echoserver.default:5005
kubectl exec -it echoserver --env
#nodeport
kubectl create service nodeport echoserver --tcp=5005:8080 --dry-run=client -o yaml > clusterip.yml
kubectl run tmp --image=busybox:1.36.1 --restart=Never -it --rm -- wget 10.96.254.0:5005
# get node IP
kubectl get svc echoserver -o wide  # get the port on the other side of 5005:portname
kubectl get nodes -o  # it will be the INTERNAL-IP
wget 192.168.65.15:31396
# create deployment webapp with 3 replicas
kubectl create deployment webapp --image=httpd --replicas=3
# Create a Service named webapp-service of type NodePort that exposes port 80 as port 80 (name it web), 
# and exposes port 9090 as port 9090 (name it metrics). Set the node port for the web port to 30080. 
# Use appropriate selectors to target your deployment webapp
kubectl create service nodeport webapp-service --dry-run=client --tcp=80:80 --dry-run=client -o yaml > webapp-service.yml
apiVersion: v1
kind: Service
metadata:
  name: webapp-service
spec:
  type: NodePort
  selector:
    app: webapp
  ports:
  - name: web
    port: 80
    targetPort: 80
    nodePort: 30080
  - name: metrics
    port: 9090
    targetPort: 9090
# Create a Deployment named database with one replica using image mysql:9.4.0 
# with these environment variables: MYSQL_ROOT_PASSWORD=secretpass and MYSQL_DATABASE=myapp.
kubectl create deployment database --image=mysql:9.4.0 --replicas=1
kubectl set env deployment/database MYSQL_ROOT_PASSWORD=secretpass MYSQL_DATABASE=myapp
# Create a ClusterIP Service named database-service that exposes port 3306 and targets the database Pods.
kubectl expose deployment database --name=database-service --port=3306 --target-port=3306 --type=ClusterIP
# Create a Deployment named frontend with two replicas using image busybox:1.35 that runs a command to continuously test the database connection 
# using the following command: sh -c "while true; do nc -zv database-service 3306; sleep 5; done"
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
spec:
  replicas: 2
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
      - name: busybox
        image: busybox:1.35
        command: ["sh", "-c"]
        args: 
        - "while true; do nc -zv database-service 3306; sleep 5; done"

kubectl logs -l app:frontend --tail=20
# chapter 18
kubectl get pods -n ingress-nginx
kubectl get ingressclasses
kubectl create ingress next-app --rule="next.example.com/app=app-service:8080" --rule="next.example.com/metrics=metrics-service:9090" --dry-run=client -o yaml > ingress.yml
kubectl get ingress
kubectl describe ingress next-app
# chapter 19
kubectl get gatewayclasses
kubectl get gateways
kubectl get httproutes
# chapter 20
kubectl run grocery-store --image=nginx:1.25.3-alpine -l app=grocery-store,role=backend --port 80
kubectl run payment-processor --image=nginx:1.25.3-alpine -l app=gpayment-processor,role=api --port 80
kubectl run coffe-shop --image=nginx:1.25.3-alpine -l app=coffee-shop,role=backend --port 80
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: api-allow
spec:
  podSelector:                          
  matchLabels:
      app: payment-processor
      role: api
  ingress:                         
  - from:
    - podSelector:
        matchLabels:
          app: coffee-shop

kubectl get networkpolicy api-allow
kubectl describe networkpolicy api-allow

apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-all
  namespace: internal-tools
spec:
  podSelector: {}                     
  policyTypes:                     
  - Ingress                        
  - Egress

apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: port-allow
  namespace: internal-tools
spec:
  podSelector:
    matchLabels:
      app: api
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: consumer
    ports:                              
    - protocol: TCP                
      port: 80