# chapter 9
kubectl run hazelcast --image=hazelcast/hazelcast:5.1.7 --port=5701 --env="DNS DOMAIN=cluster" --labels="app=hazelcast,env=prod"
kubectl logs hazelcast
kubectl exec -it hazelcast -- sh
kubectl run busybox --image=busybox:1.36.1 --rm -it --restart=Never wget 10.244.0.5:80