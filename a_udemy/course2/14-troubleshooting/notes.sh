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

ls -l /etc/kubernetes/manifests 

# worker node troubleshooting
kubectl get nodes
kubectl describe node node01
ssh node01 
top; df -h # linux troubleshooting etc.
sudo get pods -A
sudo systemctl status kubelet
sudo journalctl -u kubelet
# check certificates
openssl x509 -in /var/lib/kubelet/node01.crt -text

# network troubleshooting
kubectl get pods # make sure pods are running. can use -n for namespace or -l key=value for labels to narrow down
# test connectivity to pod directly without service
kubectl get pods -o wide  # returns IP address
kubectl get pods -l name=web-app -o=jsonpath='{.items[*].status.podIP}'  # say it returns 10.244.0.5 10.244.0.6 10.244.0.7
kubectl run -it --rm --restart=Never busybox --image=busybox sh          # create a busybox pod and enter a command line shell
for ip in 10.244.0.5 10.244.0.6 10.244.0.7; do wget -qO- $ip:9376; done  # perform a connectivity test inside kubernetes
# if it checks out, verify services. Start with configuration
kubectl get svc hostnames -o yaml
kubectl get endpointslices -l kubernetes.io/service-name=hostnames -n default # returns all IP addresses for services that name
# CoreDNS troubleshooting