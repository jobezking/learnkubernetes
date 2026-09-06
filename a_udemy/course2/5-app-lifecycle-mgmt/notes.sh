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
kubectl set image deployment/myapp-deployment nginx-container=nginx:latest  # same as above but imperative
kubectl rollout status deployment/myapp-deployment  # Check the status of a deployment rollout
kubectl rollout history deployment/myapp-deployment  # Check the rollout history of a deployment
kubectl rollout undo deployment/myapp-deployment  # Rollback to the previous deployment