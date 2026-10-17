# troubleshooting
kubectl get events
# Scenario: troubleshooting using port forwarding
1. Create deployment:
kubectl create deployment nginx --image=nginx:1.24.0 --replicas=3 --port=80
2. Get pod names
kubectl get pods
3. port forwarding command to test nginx pod from port 2500 on local machine to port 80 (doesn't return to shell prompt):
kubectl port-forward nginx-xxxx 2500:80
4. After 3 is done to create connection you can check if pod is accessible from local machine in another terminal session:
curl -Is localhost:2500 | head -n
# get interactive shell in pod to troubleshoot
kubectl exec failing-pod -it -- /bin/sh
4a. get pod logs
kubectl logs incorrect-cmd-pod
kubectl logs incorrect-cmd-pod -c mysql  # for a single container in a multi-container pod
# Troubleshooting networking and servies
1. Make sure services and pods have matching labels
kubectl describe service myservice | grep Selector
kubectl get pods --show-labels
2. Service to port mapping
kubectl get service myapp -o yaml | grep
kubectl get pods myapp-68bf896d89-qfhlv -o yaml | grep
3. check service endpoints
kubectl get endpoints myservice
4. see if service has the correct type i.e. clusterIP, nodePort. 
# Ensure that the output lists the number of Pod IP addresses and container ports expected to be selected by the Service:
kubectl get services
kubectl run tmp --image=busybox:1.37.0 -it --rm -- wget [CLUSTER-IP]:[PORT]
5. use service DNS name to check DNS resolution
kubectl run tmp --image=busybox:1.37.0 -it --rm -- wget myservice:80
kubectl run tmp --image=busybox:1.37.0 -it --rm -- wget myservice.default.svc.cluster.local:80
6. Validate CoreDNS (for DNS issues)
kubectl get pods -n kube-system -l k8s-app=kube-dns
kubectl logs -n kube-system -l k8s-app=kube-dns --tail=50
7. Vet network policies
kubectl get networkpolicies -n production
kubectl describe networkpolicy api-policy -n production
kubectl exec -it frontend-pod -n production -- curl http://backend-service:8080
8. check memory
kubectl top nodes
kubectl top pod frontend
Learn how to retrieve and interpret resource metrics
#### Nodes ####
kubectl get nodes
kubectl get pods -n kube-system
# check kube-apiserver, etcd, kube-scheduler, core-dns, kube-controller-manager, optionally cloud-controller-manager on control plane
# kubelet, kube-proxy, container runtime on control plane and worker nodes
kubectl logs kube-apiserver -n kube-system
kubectl cluster-info
kubectl cluster-info dump
#
kubectl get nodes: returns status which can include Ready and NotReady. Reason for NotReady:
1. Insufficent resources: node may be low on memory or disk space
2. Issues with the kubelet process
3. Issues with kube-proxy