Installation Prerequisites
1. running Kubernetes cluster
2. kubectl installed locally and connected to your cluster (.kube/conf)
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash
sudo mv kustomize /usr/local/bin/
kustomize version --short