# Troubleshooting application failure
Make a diagram of the application. Check the configuration and every component of the application i.e. pod, service, deployment
For web service: curl http://web-service-ip:node-port
Check labels for pods, deployments and services and make sure that they match. Verify usernames and passwords.
describe: events for pod or deployment
logs: logs for pod or deployment
kubectl logs web -f
kubectl logs web -f --previous