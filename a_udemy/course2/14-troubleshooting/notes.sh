# Troubleshooting application failure
Make a diagram of the application. Check the configuration and every component of the application i.e. pod, service, deployment
For web service: curl http://web-service-ip:node-port
Check labels for pods, deployments and services and make sure that they match. Verify usernames and passwords.
describe: events for pod or deployment
logs: logs for pod or deployment
kubectl logs web -f
kubectl logs web -f --previous
https://kubernetes.io/docs/tasks/debug/debug-application

# Control plane troubleshooting
kubectl get nodes
kubectl get pods
kubectl get pods -n kube-system  # if deployed as pods using kubeadm
# if deployed as services
# master node
service kube-apiserver status   
service kube-controller-manager status 
service kube-scheduler status
# worker node
service kubelet status
service kube-proxy status
# Check control plane component logs
kubectl logs kube-apiserver-master -n kube-system  # if kubeadm deployed pod
sudo journalctl -u kube-apiserver # if deployed as service
https://kubernetes.io/docs/tasks/debug/debug-cluster

