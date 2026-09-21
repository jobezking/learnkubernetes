1. give standard definition 
apiVersion: apps/v1
kind: Deployment
2. give appropriate name and labels
metadata:
  labels:
    app: vote
  name: vote
3. provide the number of pods that will be created with replicas and identify all pods to be controlled by the deployment with selector.matchLabels
spec:
  replicas: 1
  selector:
    matchLabels:
      app: vote
4. provide information needed to create pods. Can be copied from pod definition or created directly
  template:     # everything from metadata on down from voting-app-pod.yaml
    metadata:
      labels:
        app: vote
    spec:
      containers:
      - image: dockersamples/examplevotingapp_vote
        name: vote
        ports:
        - containerPort: 80
          name: vote 
5. The same services for pods can be used for deployments
6. To scale up or down: 
kubectl scale deployment vote --replicas=5