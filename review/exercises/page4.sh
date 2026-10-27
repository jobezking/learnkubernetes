# Chapter 16
apiVersion: v1
kind: PersistentVolume
metadata:
  name: db-pv
spec:
  capacity:                   
    storage: 1Gi         
  accessModes:           
    - ReadWriteOnce      
  hostPath:
    path: /data/db
# pv with reclaim policy and node affinity
apiVersion: v1
kind: PersistentVolume
metadata:
  name: local-pv
spec:
  capacity:
    storage: 10Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: local-storage
  local:                                               
    path: /mnt/data
  nodeAffinity:                                   
    required:
      nodeSelectorTerms:
      - matchExpressions:
        - key: kubernetes.io/hostname             
          operator: In
          values:
          - node01
          - node02
# PVC
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: db-pvc
spec:
  accessModes:                     
  - ReadWriteOnce           
  storageClassName: ""        
  resources:                  
    requests:                 
      storage: 256Mi
# Binding a PersistentVolume to a PersistentVolumeClaim by name
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: specific-pvc
spec:
  volumeName: db-pv           
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
# Mounting PVC in a pod
apiVersion: v1
kind: Pod
metadata:
  name: app-consuming-pvc
spec:
  volumes:
  - name: app-storage
    persistentVolumeClaim:          
      claimName: db-pvc      
  containers:
  - image: alpine:3.22.2
    name: app
    command: ["/bin/sh"]
    args: ["-c", "while true; do sleep 60; done;"]
    volumeMounts:
      - mountPath: "/mnt/data"
        name: app-storage
# storage class
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: fast
provisioner: kubernetes.io/gce-pd
parameters:
  type: pd-ssd
  replication-type: regional-pd
# use storageclass in pvc
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: db-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 512Mi
  storageClassName: