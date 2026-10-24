# chapter 3
#Create a Pod named nginx that uses the container image nginx:1.27.4-alpine.
kubectl run nginx --image=nginx:1.27.4-alpine
# Identify the node the Pod has been scheduled on.
kubectl get pod nginx -o wide
# Evict all Pods from the node that runs the Pod at once
kubectl drain --ignore-daemonsets node01-e --force
# chapter 4: upgrade
sudo apt update
sudo apt-cache madison kubeadm
sudo apt-mark unhold kubeadm && \
sudo apt-get update && sudo apt-get install -y kubeadm='1.37.8-*' && \
sudo apt-mark hold kubeadm
kubeadm version
sudo kubeadm upgrade plan
sudo kubeadm upgrade apply v1.37.8
kubectl drain controlplane-e --ignore-daemonsets --force
sudo apt-mark unhold kubelet kubectl && \
sudo apt-get update && sudo apt-get install -y kubelet='1.37.8-*' kubectl='1.38.x-*' && \
sudo apt-mark hold kubelet kubectl
sudo systemctl daemon-reload; sudo systemctl restart kubelet
kubectl uncordon controlplane-e
        ### workers ###
sudo apt-mark unhold kubeadm kubectl && \
sudo apt-get update && sudo apt-get install -y kubeadm='1.37.8-*' kubectl='1.37.8-*' && \
sudo apt-mark hold kubeadm kubectl
sudo kubeadm upgrade node
kubectl drain node01-e --ignore-daemonsets --force
sudo apt-mark unhold kubelet && \
sudo apt-get update && sudo apt-get install -y kubelet='1.38.x-*' && \
sudo apt-mark hold kubelet
sudo systemctl daemon-reload; sudo systemctl restart kubelet
kubectl uncordon node01-e
#chapter 5
# which version of etcd is running?
kubectl get pods -n kube-system | grep etcd
kubectl describe pod etcd-controlplane-e -n kube-system | grep Image:
# Use etcdctl and etcdutl to back up etcd to /opt/etcd.bak and restore etcd from the snapshot file using data directory /var/bak
sudo ETCDCTL_API=3 etcdctl \
  --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key snapshot save /opt/etcd.bak

etcdutl --data-dir /var/bak snapshot restore /opt/etcd.bak