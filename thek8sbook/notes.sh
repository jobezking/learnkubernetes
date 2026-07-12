kubectl get nodes
kubectl config view [--flatten | --minify | --output='json' | --output='yaml']
kubectl config get-contexts
kubectl get pods
kubectl explain pods --recursive | more
kubectl explain pods.spec.containers
kubectl explain pods.spec.restartPolicy
kubectl apply -f pod.yaml
kubectl get pods hello-pod -o yaml
kubectl describe pod hello-pod
kubectl logs
kubectl logs hello-pod
kubectl logtest --container syncer

kubectl exec hello-pod -- ls /tmp
kubectl exec it hello-pod -- sh