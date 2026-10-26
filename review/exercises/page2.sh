# chapter 9
kubectl run hazelcast --image=hazelcast/hazelcast:5.1.7 --port=5701 --env="DNS DOMAIN=cluster" --labels="app=hazelcast,env=prod"
kubectl logs hazelcast
kubectl exec -it hazelcast -- sh
kubectl get pod hazelcast -o wide
kubectl run busybox --image=busybox:1.36.1 --rm -it --restart=Never wget 10.244.0.5:80
kubectl get ns
kubectl create ns code-red
kubectl get ns code-red
kubectl run podcr --image=nginx:1.25.1 -n code-red
kubectl get pods -n code-red
kubectl config set-context --curent --namespace=code-red
kubectl get pods
#chapter 10
kubectl create configmap NAME [--from-file=[key=]source] [--from-literal=key1=value1] [--dry-run=server|client|none]
kubectl create configmap my-config --from-env-file=/opt/envs/bar.env --dry-run=client -o yaml > configmap.yml
kubectl create configmap db-configf --from-file=db.json --dry-run=client -o yaml > configmapf.yml 
kubectl create configmap db-config --from-literal=DB_HOST=mysql-service --from-literal=DB_USER=backend
apiVersion: v1
kind: Pod
metadata:
  name: backend
spec:
  containers:
  - image: nginx:1.21.1
    name: backend
    envFrom:
    - configMapRef:
        name: db-config
#
kubectl exec backend -- env
kubectl exec -it backend -- /bin/sh
kubectl create secret generic db-creds --from-literal=pwd=s3cre! --dry-run=client -o yaml > configmap.yml
apiVersion: v1
kind: Pod
metadata:
  name: backend
spec:
  containers:
  - image: bmuschko/web-app:1.0.1
    name: backend
    envFrom:
    - secretRef
      name: db-creds

cp ~/.ssh/id_rsa ssh-privatekey
kubectl create secret generic secret-ssh-auth --from-file=ssh-privatekey --type=kubernetes.io/ssh-auth
apiVersion: v1
kind: Pod
metadata:
  name: backend
spec:
  containers:
  - image: bmuschko/web-app:1.0.1
    name: backend
    volumeMounts:
    - name: ssh-volume
      mountPath: /var/app
      readOnly: true                   volumes:
  - name: ssh-volume
    secret:
      secretName: secret-ssh-auth
kubectl exec -it backend -- /bin/sh
#chapter 11
kubectl create deployment nginx --image=nginx:1.23.0 --replicas=3 --dry-run=client -o yaml > nginxdeployment.yml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
  labels:
    tier: backend
spec:
  replicas: 3
  selector:
    matchLabels:
      app: v1
  template:
    metadata:
      labels:
        app: v1
    spec:
      containers:
      - name: nginx
        image: nginx:1.23.0
kubectl set image (-f FILENAME | TYPE NAME) CONTAINER_NAME_1=CONTAINER_IMAGE_1 ... CONTAINER_NAME_N=CONTAINER_IMAGE_N
kubectl set image deployment/nginx nginx=nginx:1.23.4 
kubectl annotate [--overwrite] (-f FILENAME | TYPE NAME) KEY_1=VAL_1 ... KEY_N=VAL_N [--resource-version=version]
kubectl annotate deployment/nginx kubernetes.io/change-cause="Pick up patch version" --overwrite
kubectl rollout status deployment/nginx
kubectl rollout history deployment/nginx
kubectl rollout undo (TYPE NAME | TYPE/NAME) [flags]
kubectl rollout undo deployment/nginx --to-revision=1
# chapter 12
kubectl scale [--resource-version=version] [--current-replicas=count] --replicas=COUNT (-f FILENAME | TYPE NAME)
kubectl autoscale (-f FILENAME | TYPE NAME | TYPE/NAME) [--min=MINPODS] --max=MAXPODS [--cpu=CPU] [--memory=MEMORY]
kubectl get|describe hpa
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.23.4
        resources:
          requests:
            cpu: "0.5"
            memory: "500Mi"
          limits:
            memory: "500Mi"
kubectl autoscale deployment nginx --min=3 --max=8 --cpu=75% --memory=60%