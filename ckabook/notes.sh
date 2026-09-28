# Kubernetes primitive structure:
API Version: defines structure of the primitive
Kind: defines the type of primitive i.e. pod, service etc.
Metadata: higher level info about object
Spec: specification. The desired state after object has been created
Status: the actual state of the object

kubectl explain: time-saving tool during exam i.e.
kubectl explain pods.spec.containers
kubectl explain deployment.spec.strategy.rollingUpdate