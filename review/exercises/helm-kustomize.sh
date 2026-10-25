helm repo list
helm search hub nginx
helm repo add jenkinsci https://charts.jenkins.io
helm install my-jenkins jenkinsci/jenkins
helm search repo
kubectl get all | grep jenkins
helm show values jenkinsci/jenkins
helm list --all-namespaces
helm repo update
helm upgrade my-jenkins jenkinsci/jenkins
helm uninstall my-jenkins
#
# kustomize needs kustomization.yaml
kubectl kustomize <target>  # dry run
kubectl apply -k <target>  # process with kustomize