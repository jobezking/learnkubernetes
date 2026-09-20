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
kubect get nodes -o wide
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
ls -la /etc/cni/net.d/  # check coredns configuration directory
journalctl -u kubelet | grep -i cni | tail -10  # check coredns logs
kubectl get pods --namespace=kube-system -l k8s-app=kube-dns
kubectl get endpointslices -l kubernetes.io/service-name=kube-dnss -n kube-system
kubectl exec -it podname -- cat /etc/resolv.conf
kubectl exec -it busybox -- nslookup kubernetes.default.svc.cluster.local
kubectl exec -it busybox -- nslookup my-app-service.default.svc.cluster.local
# kube-proxy troubleshooting
check kube-proxy pod status; make sure all daemonsets are running
kubectl get pods --namespace=kube-system -l k8s-app=kube-proxy
kubectl logs kube-proxy-1343q -n kube-system
kubectl get configmap kube-proxy -n kube-system -o yaml
ipvsadm -ln # check network


# JSON Path in Kubectl
1. identify the kubectl command i.e. kubectl get nodes, kubectl get pods
2. learn json output of command i.e. kubectl get nodes -o json; kubectl get pods -o json
3. Form JSON Path query
4. use the JSON Path query with kubectl command
kubectl get nodes -o=jsonpath='{.items[*].metadata.name}'
kubectl get nodes -o=jsonpath='{.items[*].status.nodeInfo.architecture}'
kubectl get nodes -o=jsonpath='{.items[*].status.capacity.cpu}'
#combine
kubectl get nodes -o=jsonpath='{.items[*].metadata.name}{.items[*].status.capacity.cpu}'
kubectl get nodes -o=jsonpath='{.items[*].metadata.name}{"\n"}{.items[*].status.capacity.cpu}'

###
FOR EACH NODE                                       '{range.items[*]}   
    PRINT NODE NAME \t PRINT CPU COUNT \n               {.metadata.name} {"\t"}{.status.capacity.cpu} {"\n"}
END FOR                                               {end}'
###
kubectl get nodes -o=jsonpath='{range.items[*]} {.metadata.name} {"\t"}{.status.capacity.cpu} {"\n"} {end}'
kubectl get nodes -o=custom-columns=<COLUMN NAME>:<JSON PATH>
kubectl get nodes -o=custom-columns=NODE:.metadata.name,CPU:.status.capacity.cpu
kubectl get nodes --sort-by=.metadata.name
kubectl get nodes --sort-by=.status.capacity.cpu