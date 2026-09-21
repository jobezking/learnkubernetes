kubectl rollout status deployment/<deployment-name> # Check the status of a deployment rollout
kubectl rollout status deployment/myapp-deployment

kubectl rollout history deployment/<deployment-name> # Check the rollout history of a deployment

#Rolling update: default deployment strategy

# Example
kubectl apply -f deployment-definition.yml  # creates original deployment
kubectl apply -f deployment-definition-mod.yml  # creates modified deployment, triggers rolling update
# OR
kubectl set image deployment/myapp-deployment nginx-container=nginx:latest  # updates the image for the nginx container in the deployment
# The second approach is imperative and better suited for the CKA exam but it does not create or modify configuration files

# Entire lifecycle management of deployments
kubectl create -f deployment-definition.yml  # creates original deployment
kubectl get deployments # Lists all deployments
kubectl apply -f deployment-definition-mod.yml  # creates modified deployment, triggers rolling update
kubectl set image deployment/<deployment-name> <container>=<image> # same as above but imperative
kubectl set image deployment/myapp-deployment nginx-container=nginx:latest  # example
kubectl set image deployment/frontend simple-webapp=kodekloud/webapp-color:v2 # example
kubectl rollout status deployment/myapp-deployment  # Check the status of a deployment rollout
kubectl rollout history deployment/myapp-deployment  # Check the rollout history of a deployment
kubectl rollout undo deployment/myapp-deployment  # Rollback to the previous deployment

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

#Vertical Pod scaling

FEATURE_GATES=InPlacePodVerticalScaling=true
kubectl apply -f https://github.com/kubernetes/kubernetes/autoscaler/releases/latest/download/vertical-pod-autoscaler.yaml

#updateMode values
Off      # only recommends changes without implementing them
Initial  #only changes on pod creation and not later
Recreate  # evicts pods if usage goes beyond range
Auto      #Updates existing pods to recommended numbers. 

kubectl get crds | grep verticalpodautoscaler

kubectl get pods -n kube-system | grep vpa

kubectl logs -n kube-system deployment/vpa-updater

kubectl describe vpa flask-app
kubectl get vpa