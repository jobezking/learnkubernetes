# CKA Exam Study Sheet: Kubernetes Troubleshooting Guide

A targeted cheatsheet for diagnosing and resolving failures across Master Nodes, Worker Nodes, and Kubernetes Resources during the CKA exam.

---

## 1. Master Node (Control Plane) Troubleshooting

Control plane components usually run as **Static Pods** managed directly by `kubelet` via manifests in `/etc/kubernetes/manifests/`.

### Quick Diagnostic Steps
```bash
# 1. Check control plane pod statuses
kubectl get pods -n kube-system

# 2. If API server is down, use crictl or docker directly on the master node
sudo crictl ps -a
sudo crictl logs <container-id>

# 3. Check kubelet status on master (manages static pods)
sudo systemctl status kubelet
sudo journalctl -u kubelet -e --no-pager
```

### Common Failures & Fixes

| Component | Common Symptoms | Root Cause / Check First | Common Solution |
| :--- | :--- | :--- | :--- |
| **`kube-apiserver`** | `The connection to the server ... was refused`<br>`Error from server (InternalError)` | Syntax error in `/etc/kubernetes/manifests/kube-apiserver.yaml`, expired certificates, or `etcd` down. | Fix YAML typos in manifest; renew certs via `kubeadm certs renew all`. |
| **`etcd`** | `apiserver` crashing, `etcdserver: request timed out` | Disk full/slowness, expired etcd certs, corrupted data dir (`/var/lib/etcd`). | Check storage (`df -h`), check logs (`crictl logs <etcd-container>`). Restore from snapshot if corrupted. |
| **`kube-scheduler`** | Pods remain in `Pending` state with no node assignment. | Static pod manifest broken or missing; controller crashed. | Inspect `/etc/kubernetes/manifests/kube-scheduler.yaml` logs. |
| **`kube-controller-manager`** | Deployments don't scale, PVCs stuck in `Pending`, node states not updating. | Manifest syntax error, missing service account keys or certificates. | Inspect `/etc/kubernetes/manifests/kube-controller-manager.yaml`. |

---

## 2. Worker Node Troubleshooting

Worker node issues usually cause nodes to report `NotReady` or fail to run workload pods.

### Quick Diagnostic Workflow

```bash
# Step 1: Check node status and events
kubectl describe node <node-name>

# Step 2: SSH into the worker node
ssh <node-name>

# Step 3: Check system services
sudo systemctl status kubelet
sudo systemctl status containerd   # or cri-o / docker

# Step 4: Inspect system logs
sudo journalctl -u kubelet -e --no-pager
sudo journalctl -u containerd -e --no-pager
```

### Common Worker Node Failures

#### Scenario A: Node in `NotReady` State
* **Cause 1: Swap enabled**
  * *Fix:* `sudo swapoff -a` and comment out swap entries in `/etc/fstab`.
* **Cause 2: Container Runtime down (`containerd`)**
  * *Fix:* `sudo systemctl restart containerd && sudo systemctl restart kubelet`
* **Cause 3: Network CNI plugin missing or crashed**
  * *Fix:* Check pods in `kube-system` (e.g., Flannel, Calico, Weave). Ensure CNI configuration exists in `/etc/cni/net.d/`.
* **Cause 4: Disk space exhausted**
  * *Fix:* Clear unused images/containers: `sudo crictl rmi --prune`.

#### Scenario B: Worker Node Cannot Join Cluster
* **Cause:** Expired join token or incorrect discovery hash.
* **Fix:** Generate a new join command on the master node:
  ```bash
  kubeadm token create --print-join-command
  ```

---

## 3. Resource & Workload Troubleshooting

### Diagnostic Decision Tree

```
Pod Issue
 ├── State: Pending
 │    ├── Describe Pod: "0/N nodes available" -> Taints / Tolerations / Affinities
 │    ├── Check limits: Insufficient Memory/CPU on nodes
 │    └── PVC stuck in Pending -> StorageClass/PV binding issue
 │
 ├── State: CrashLoopBackOff / Error
 │    ├── Check application logs: kubectl logs <pod> [--previous]
 │    ├── Command/args misconfigured in pod spec
 │    └── Liveness probe failing
 │
 └── State: ImagePullBackOff / ErrImagePull
      ├── Typo in image name or tag
      └── Private registry missing Secret (imagePullSecrets)
```

### Essential Resource Troubleshooting Commands

```bash
# --- Pods & Application Logs ---
kubectl describe pod <pod-name>
kubectl logs <pod-name> -c <container-name> --previous
kubectl exec -it <pod-name> -- /bin/sh

# --- Events & Debugging ---
kubectl get events --sort-by='.metadata.creationTimestamp' -n <namespace>
kubectl run debug-pod --rm -i --tty --image=busybox -- nslookup <service-name>

# --- Metrics & Resources ---
kubectl top nodes
kubectl top pods --all-namespaces

# --- Network & Services ---
kubectl get endpoints <service-name>
# If Endpoints are missing/empty: check Service selector labels match Pod labels!
```

---

## 4. Key CKA Troubleshooting Checklist

1. **Systemd Services First:** When a node is `NotReady`, always check `systemctl status kubelet` and container runtime before anything else.
2. **Read the Logs End-to-End:** Use `journalctl -u kubelet -f` or `kubectl logs` with `--previous` to see what failed immediately before a crash.
3. **Validate Certificates:** Check expired certificates with:
   ```bash
   kubeadm certs check-expiration
   ```
4. **Service Selectors:** If a Service cannot reach a Pod, check if `kubectl get ep <service-name>` lists IP addresses. If empty, fix label selectors in the Service definition.