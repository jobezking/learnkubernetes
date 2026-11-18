1. Create deployment frontend-webapp in production-env namespace with image nginx:1.29-alpine and 3 replicas. Pods will have label app=frontend-webapp
kubectl create deployment frontend-webapp --image=nginx:1.29-alpine --replicas=3 -n production-env
Verify:
kubectl rollout status deployment/frontend-webapp -n production-env
kubectl get pods -n production-env --show-labels
kubectl get deployment frontend-webapp -n production-env -o jsonpath='{.spec.template.spec.containers[0].image}'
2. Mark k8s-worker-01 with label disk=nvme. Create pod data-processor in scheduling-lab namespace with image redis:7.4-alpine to only run on nodes with label disk-nvme.
Cannot be scheduled on any other node now or later.
kubectl label nodes k8s-worker-01 disk=nvme
kubectl run data-processor --image=redis:7.4-alpine --overrides='{"spec": {"nodeSelector": {"disk": "nvme"}}}' -n scheduling-lab
OR
kubectl run data-processor --image=redis:7.4-alpine -n scheduling-lab --dry-run=client -o yaml > dataprocessor.yaml
and add under spec: aligned with containers:
nodeSelector:
  disk: nvme
Verify:
kubectl get nodes --show-labels
kubectl get nodes --selector=disk=nvme
kubectl get pods data-processor -n scheduling-lab -o wide
