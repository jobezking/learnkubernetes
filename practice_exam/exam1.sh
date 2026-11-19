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
3. Create PersistentVolume app-data-pv. Capacity: 2Gi, Access Mode: ReadWriteOnce, Storage Class: manual, backed by directory 
/opt/k8s/app-data on node k8s-worker-01. Create PersistentVolumeClaim app-data-pvc in storage-lab namespace with capacity 1Gi, Access Mode: ReadWriteOnce, 
Storage Class: manual. The claim must be bound to the PersistentVolume app-data-pv
#
apiVersion: v1
kind: PersistentVolume
metadata:
  name: app-data-pv
spec:
  capacity:
    storage: 2Gi
  accessModes:
    - ReadWriteOnce
  storageClassName: manual
  persistentVolumeReclaimPolicy: Retain
  hostPath:
    path: /opt/k8s/app-data
#
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: app-data-pvc
  namespace: storage-lab
spec:
  storageClassName: manual
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
#
apiVersion: v1
kind: Pod
metadata:
  name: app-data-pod
  namespace: storage-lab
spec:
  nodeSelector:
    disk: nvme
  containers:
    - name: app-data-container
      image: nginx:1.29-alpine
      volumeMounts:
        - mountPath: "/usr/share/nginx/html"
          name: app-data-volume
  volumes:
    - name: app-data-volume
      persistentVolumeClaim:
        claimName: app-data-pvc
4. PersistentVolume audit-archive-pv. Capacity: 5Gi, Storage Class: manual, backed by directory /opt/k8s/audit-archive on node k8s-worker-01. 
Data must not be erased when PVC is deleted; admin has to release volume manually. persistentVolumeReclaimPolicy: Retain. 
Mounted as ordinary directory: volumeMode: Filesystem. mounted by single pod at a time: Access Mode: ReadWriteOnce. 
PersistentVolume build-scratch-pv. Capacity: 1Gi, Storage Class: manual, backed by directory /opt/k8s/build-scratch on node k8s-worker-01.
Cluster should clean up on its own. persistentVolumeReclaimPolicy: Delete. 
Mounted as ordinary directory: volumeMode: Filesystem. mounted by single pod at a time: Access Mode: ReadWriteOnce. 
#
apiVersion: v1
kind: PersistentVolume
metadata:
  name: audit-archive-pv
spec:
  capacity:
    storage: 5Gi
  accessModes:
    - ReadWriteOnce
  storageClassName: manual
  persistentVolumeReclaimPolicy: Retain
  volumeMode: Filesystem
  hostPath:
    path: /opt/k8s/audit-archive
#
apiVersion: v1
kind: PersistentVolume
metadata:
  name: build-scratch-pv
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteOnce
  storageClassName: manual
  persistentVolumeReclaimPolicy: Delete
  volumeMode: Filesystem
  hostPath:
    path: /opt/k8s/build-scratch