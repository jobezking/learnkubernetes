# learnkubernetes
Notes Configuration Files And Code From Various Kubernetes Training Books
Reference manual: https://kubernetes.io/docs 
Blog: https://kubernetes.io/blog 
Helm: https://helm.sh/docs

Furthermore, the instructions will ask you to work in a namespace other than default. Make sure to set the context and namespace as the first course of action before working on a question. The following command sets the context and the namespace as a one-time action: 
$ kubectl config set-context <context-of-question> --namespace=<namespace-of-question>
$ kubectl config use-context <context-of-question>
