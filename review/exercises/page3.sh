# chapter 13
kubectl create namespace rq-nm
kubectl create quota NAME [--hard=key1=value1,key2=value2] [--scopes=Scope1,Scope2] [--dry-run=server|client|none]
kubectl create quota rq-nm-quota --hard=cpu=1,memory=1024Mi,pods=2 --namespace=rq-nm --dry-run=client -o yaml > rq.yaml
#Will need to update it to fit below
apiVersion: v1
kind: ResourceQuota
metadata:
  name: awesome-quota
  namespace: team-awesome
spec:
  hard:
    pods: 2                        
    requests.cpu: "1"         
    requests.memory: 1024Mi   
    limits.cpu: "4"           
    limits.memory: 4096Mi
# chapter 14
#node selectors
kubectl label node multi-node-m03 disk-ssd
kubectl get nodes --show-labels
#use spec.NodeSelector to assign pod
apiVersion: v1
kind: Pod
metadata:
  name: app
spec:
  nodeSelector:                
    disk: ssd             
  containers:
  - name: nginx
    image: nginx:1.27.1
# Node affinity
apiVersion: v1
kind: Pod
metadata:
  name: app
spec:
  affinity:
    nodeAffinity:                                              
      requiredDuringSchedulingIgnoredDuringExecution:   
        nodeSelectorTerms:
        - matchExpressions:                             
          - key: disk                                   
            operator: In                                
            values:                                     
            - ssd                                       
            - hdd                                       
  cont iners:
  - name: nginx
    image: nginx:1.27.1
# Node Anti-affinity
apiVersion: v1
kind: Pod
metadata:
  name: app
spec:
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
        - matchExpressions:
          - key: disk
            operator: NotIn                                             
            values:
            - ssd
            - ebs
  containers:
  - name: nginx
    image: nginx:1.27.1
# Taints
kubectl taint node multi-node-m02 special=true:NoSchedule
kubectl get node node01 -o yaml | grep -C 3 taints:
# Assign toleration to pod
apiVersion: v1
kind: Pod
metadata:
  name: app
spec:
  tolerations:                
  - key: "special"         
    operator: "Equal"      
    value: "true"          
    effect: "NoSchedule"   
  containers:
  - name: nginx
    image: nginx:1.27.1
#
kubectl label node node02-e color=green
kubectl label node node01-e color=red
kubectl run select --image=nginx:1.27.1 --dry-run=client -o yaml > select.yaml
set spec.nodeSelector.color: green or red
kubectl taint NODE NAME KEY_1=VAL_1:TAINT_EFFECT_1 ... KEY_N=VAL_N:TAINT_EFFECT_N
kubectl taint nodes node02-e exclusive=yes:NoExecute
apiVersion: v1
kind: Pod
metadata:
  name: taint
spec:
  tolerations:
  - key: "exclusive"
    operator: "Equal"
    value: "yes"
    effect: "NoExecute"
  containers:
  - name: nginx
    image: nginx:1.27.1