First, create the alpaca-prod deployment and set the ver, app, and env labels:

kubectl run alpaca-prod --image=gcr.io/kuar-demo/kuard-amd64:blue --replicas=2 --labels="ver=1,app=alpaca,env=prod"

Next, create the alpaca-test deployment and set the ver, app, and env labels with the appropriate values:

kubectl run alpaca-test --image=gcr.io/kuar-demo/kuard-amd64:green --replicas=1 --labels="ver=2,app=alpaca,env=test"

Finally, create two deployments for bandicoot. Here we name the environments prod and staging:

kubectl run bandicoot-prod --image=gcr.io/kuar-demo/kuard-amd64:green --replicas=2 --labels="ver=2,app=bandicoot,env=prod"

kubectl run bandicoot-staging --image=gcr.io/kuar-demo/kuard-amd64:green --replicas=1 --labels="ver=2,app=bandicoot,env=staging"

kubectl get deployments --show-labels
kubectl get pods --show-labels
kubectl label deployments alpaca-test "canary=true"
kubectl get deployments -L canary
kubectl label deployments alpaca-test "canary-" #removes the canary label from the deployment
kubectl get pods --selector="ver=2"

kubectl get pods --selector="app=bandicoot,ver=2"
kubectl get pods --selector="app in (alpaca,bandicoot)"
kubectl get deployments --selector="canary"
kubectl get deployments --selector='!canary'
kubectl get pods -l 'ver=2,!canary'

kubectl delete deployments --all

kubectl create deployment alpaca-prod --image=gcr.io/kuar-demo/kuard-amd64:blue --port=8080
kubectl scale deployment alpaca-prod --replicas 3
kubectl expose deployment alpaca-prod
kubectl create deployment bandicoot-prod --image=gcr.io/kuar-demo/kuard-amd64:green --port=8080
kubectl scale deployment bandicoot-prod --replicas 2
kubectl expose deployment bandicoot-prod
kubectl get services -o wide

Burns, Brendan; Beda, Joe; Hightower, Kelsey; Evenson, Lachlan. Kubernetes: Up and Running: Dive into the Future of Infrastructure (p. 128). O'Reilly Media. Kindle Edition. 