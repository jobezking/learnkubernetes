FIND AN ACTUAL GOOD SOURCE TO STUDY KUSTOMIZATION

# Installation Prerequisites
# 1. running Kubernetes cluster
# 2. kubectl installed locally and connected to your cluster (.kube/conf)
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash
sudo mv kustomize /usr/local/bin/
kustomize version --short

# kustomization.yaml has to be created and placed in the same directory as the managed k8s yaml manifests.
kustomize build yamldirectory
# i.e
kustomize build k8s_configs

# It will print output of final configuration to terminal. It does not apply. 
# The output will need to be either redirected to "kubectl apply -f" or stored to a yaml file.
kustomize build k8s_configs/ | kubectl apply -f

# To delete
kustomize build k8s_configs/ | kubectl delete -f

# kustomize build is has no recursive option to read subfolders. To handle subfolders place kustomization.yaml in top folder
# inside kustomization yaml explicitly specify using paths relative o kustomization.yaml all of the yaml files that will be processed i.e.
resources:
  - api/api-depl.yaml
  - db/db-depl.yaml
# Or you can put a kustomization.yaml file in every subdirectory that refers to all the managed files in the directory. 
# The root directory kustomization.yaml file then merely needs to refer to all the subdirectories:
resources:
  - api 
  - db
  - cache 
  - kafka  

kubectl apply -k yamldirectory  # alternative to kustomize build yamldirectory | kubectl apply -f

# Common Transformations
commonLabel: adds a label to all k8s resources
namePrefix: adds a common prefix to all resource names
nameSuffix: adds a common suffix to all resource names
Namespace: adds a common namespace to all resources
commonAnnotations: adds an annotation to all resources

commonLabels:
  org: KodeKloud

namespace: lab

namePrefix: KodeKloud-
nameSuffix: -dev

commonAnnotations:
  branch: master

# Image Transformer. Below is isleading as it replaces the image - spec.containers.image - not spec.containers.name
images:
  - name: nginx
    newName: haproxy

# To add tag:
images:
  - name: nginx
    newTag: "2.4"

# Can be combined:
images:
  - name: nginx
    newName: haproxy
    newTag: "2.4"

# Patches  Require 3 values: 
# operation type (add/remove/replace), target (kind, version/group, Name, Namespace, labelSelector, AnnotationSelector), Value (only for add/replace)

# JSON 6902 Patch
patches:
  - target:
      kind: Deployment
      name: api-deployment

      patch: |-
        - op: replace
          path: /metadata/name
          value: web-deployment


  - target:
      kind: Deployment
      name: api-deployment

      patch: |-
        - op: replace
          path: /spec/replicas
          value: 5

patches:
  - target:
      kind: Deployment
      name: api-Deployment
    patch: |-
      - op: replace
        path: /spec/replicas
        value: 5

# Strategic merge patch is as if you are performing a regular k8s config
patches:
  - patch: |-
    apiVersion: apps/v1
    kind: Deployment'
    metadata:
      name: api-deployment
    spec:
      replicas: 5

# You can also do a separate file
patches:
  - path: replica-patch.yaml
    target: 
      kind: Deployment
      name: nginx-deployment

# replica-patch.yaml
- op: replace
  path: /spec/replicas
  value: 5