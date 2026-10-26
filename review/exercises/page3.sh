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