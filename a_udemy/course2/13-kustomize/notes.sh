# Installation Prerequisites
# 1. running Kubernetes cluster
# 2. kubectl installed locally and connected to your cluster (.kube/conf)
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash
sudo mv kustomize /usr/local/bin/
kustomize version --short

# kustomization.yaml has to be created and placed in the same directory as the managed k8s yaml manifests.
kustomize build yamldirectory
# i.e
kustomize build k8s_configs

# It will print output of final configuration to terminal. It does not apply. 
# The output will need to be either redirected to "kubectl apply -f" or stored to a yaml file.
kustomize build k8s_configs/ | kubectl apply -f

# To delete
kustomize build k8s_configs/ | kubectl delete -f

