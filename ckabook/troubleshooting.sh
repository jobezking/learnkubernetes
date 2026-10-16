# troubleshooting
kubectl get events
#Scenario: troubleshooting using port forwarding
1. Create deployment:
kubectl create deployment nginx --image=nginx:1.24.0 --replicas=3 --port=80
2. Get pod names
kubectl get pods
3. port forwarding command to test nginx pod from port 2500 on local machine to port 80 (doesn't return to shell prompt):
kubectl port-forward nginx-xxxx 2500:80
4. After 3 is done to create connection you can check if pod is accessible from local machine in another terminal session:
curl -Is localhost:2500 | head -n