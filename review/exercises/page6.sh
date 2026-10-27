# chapter 21
kubectl get pods
kubectl describe pod secret-pod
kubectl get events
kubectl create deployment nginx --image=nginx:1.24.0 --replicas=3 --port=80
kubectl get pods
kubectl port-forward nginx-xxx-xxx 2500:80
curl -Is localhost:2500 | head -n 1
kubectl logs pod
kubectl exec failing-pod -it -- /bin/sh
kubectl describe service myservice
kubectl get pods --show-labels
kubectl get service myapp -o yaml | grep targetPort:
kubectl get pods myapp-68bf896d89-qfhlv -o yaml | grep containerPort:
kubectl get endpoints myservice
kubectl get services
kubectl run tmp --image=busybox:1.37.0 -it -rm -- wget [CLUSTER-IP]:[PORT]
kubectl run tmp --image=busybox:1.37.0 -it -rm -- wget myservice:[PORT]
kubectl get pods -n kube-system -l k8s-app=kube-dns
kubectl logs -n kube-system -l k8s-app=kube-dns --tail=50
kubectl get networkpolicies -n production
kubectl describe networkpolicy api-policy -n production
kubectl exec -it frontend-pod -n production -- curl http://backend-service:8080
kubectl top nodes
kubectl top pod frontend
# chapter 22
kubectl get nodes
kubectl get pods -n kube-system
kubectl logs kube-apiserver -n kube-system
kubectl cluster-info
kubectl cluster-info dump
# worker Node not ready
# Insufficient resources
# check kubelet process
# check kube-proxy
kubectl describe node01-e
top
df -h
sudo systemctl status kubelet
sudo journalctl -fxu kubelet.service
sudo systemctl restart kubelet
openssl x509 -in /var/lib/kubelet/pki/kubelet.crt
kubeadm certs check-expiration
kubeadm certs renew all
kubectl get pods -n kube-system
kubectl describe pod kube-proxy-xxxx -n kube-system
kubectl describe daemonset kube-proxy -n kube-system