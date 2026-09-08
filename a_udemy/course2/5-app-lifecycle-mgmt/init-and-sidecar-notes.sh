InitContainers
Understanding Init and Sidecar Containers in Kubernetes
In a multi-container Pod, each container is expected to run a process that stays alive for the entire lifecycle of the Pod.

For example, in a Pod with a web application and a logging agent, both containers are expected to remain active throughout the Pod’s lifecycle. The process in the logging agent container must stay alive as long as the web application is running. If any main container fails and the Pod's restartPolicy is Always or OnFailure, the entire Pod is restarted.

Pod Restart Behavior in Multi-Container Pods
In a multi-container Pod, the restartPolicy applies at the container level, not the Pod level. If a container exits, the kubelet restarts that individual container in place according to the policy—other containers in the Pod are unaffected and keep running.

Always (default): restarts the container after any exit, regardless of exit code.

OnFailure: restarts only on a non-zero exit code.

Never: never restarts.

The policy applies to app containers and regular init containers. Sidecar containers (init containers with their own container-level restartPolicy: Always) always restart regardless of the Pod's restartPolicy.

Kubernetes does not restart the entire Pod when one container fails. The Pod is recreated only by its controller when the node dies or the Pod is removed.

What is an Init Container?
An init container is a special container that runs before the main containers in a Pod. Each init container must succeed (exit 0) before the next one is started. Once all init containers complete, the regular containers start simultaneously.

They are configured similarly to other containers but are placed in the initContainers section of the Pod spec.

If any init container fails, the entire Pod is restarted and all init containers are rerun from the beginning.

✅ Using Init Containers
apiVersion: v1
kind: Pod
metadata:
  name: myapp-pod
  labels:
    app: myapp
spec:
  initContainers:
    - name: init-myservice
      image: busybox:1.31
      command: ["sh", "-c", "until nslookup myservice; do echo waiting for myservice; sleep 2; done;"]
    - name: init-mydb
      image: busybox:1.31
      command: ["sh", "-c", "until nslookup mydb; do echo waiting for mydb; sleep 2; done;"]
  containers:
    - name: myapp-container
      image: busybox:1.28
      command: ["sh", "-c", "echo The app is running! && sleep 3600"]
Native Sidecar Containers (Kubernetes 1.33+)
Starting with Kubernetes v1.33, sidecar containers are natively supported. This allows sidecar containers to follow a defined lifecycle relative to the main containers in the Pod — without requiring entrypoint hacks.

✳️ How Native Sidecars Work
Declared using the restartPolicy: Always field inside the initContainers block.

Kubernetes treats such containers as sidecars, ensuring they:

Start before main containers.

Run alongside them.

Shut down after the main containers complete.

✅ Example: Native Sidecar Configuration
apiVersion: v1
kind: Pod
metadata:
  name: sidecar-example
spec:
  initContainers:
    - name: sidecar-logger
      image: busybox:1.31
      restartPolicy: Always
      command: ["sh", "-c", "while true; do echo Sidecar running; sleep 10; done"]
  containers:
    - name: main-app
      image: busybox:1.31
      command: ["sh", "-c", "echo Main app starting; sleep 60"]
In this setup:

The sidecar-logger container behaves like a sidecar, though declared in initContainers.

It uses restartPolicy: Always to stay alive throughout the Pod lifecycle.

Kubernetes starts the sidecar first, waits for readiness, then starts the main app.

📖 Learn more from the official documentation:
👉 Kubernetes Docs: Init Containers
👉 Kubernetes Docs: Native Sidecar Containers