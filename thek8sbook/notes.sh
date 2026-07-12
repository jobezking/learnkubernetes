kubectl get nodes
kubectl config view [--flatten | --minify | --output='json' | --output='yaml']
kubectl config get-contexts
kubectl get pods
kubectl get pods --watch
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

kubectl edit pod hello-pod
kubectl delete pod hello-pod initpod
kubectl delete svc k8sbook svc-sidecar
kubectl delete -f pod.yaml
kubectl delete -f pod.yaml initpod.yaml