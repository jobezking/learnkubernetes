$HOME/.kube/config
kubectl config view [--flatten | --minify | --output='json' | --output='yaml']
kubectl config set-context my-context --namespace=mystuff  # creates context
kubectl config use-context my-context  # makes context active
kubectl get pods
kubectl get pods --watch
kubectl explain pods
kubectl explain pods --recursive | more
kubectl explain pods.spec.containers
kubectl explain pods.spec.restartPolicy
kubectl get pod test -o yaml > test.yaml
kubectl get pod test -o wide
kubectl exec -it test -- sh 
kubectl attach -it <pod-name>
kubectl cp nginx:/www/var/html/index.html /home/user/test.html  #copies file from running container to your local machine.
kubectl port-forward <pod-name> 8080:80 # opens up a connection that forwards traffic from the local machine on port 8080 to the remote container on port 80.
kubectl get nodes, pods, services
kubectl describe nodes kube1
kubectl getcomponentstatuses
kubectl get daemonSets --namespace=kube-system kube-proxy
kubectl get deployments --namespace-kube-system core-dns
kubectl get services --namespace-kube-system core-dns
kubectl label pods bar color=red  # add label color
kubectl label pods bar color-    # remove label color
kubectl delete pod nginx-pod
kubectl top nodes
kubectl top pods --all-namespaces
kubectl cordon  #prevent future pods from being scheduled on the machine that the command was entered
kubectl drain   #remove any pod currently running on machine
kubectl uncordon    #re-enable pod scheduling