totalSeconds() {
  { set +x; } 2>/dev/null
  echo `expr $(date +%s) - $start`
  set -x
}
start=`date +%s`
kubectl version
set -x
kubectl create ns hello
totalSeconds
kubens hello
kubectl create deployment hello-node --image=gcr.io/hello-minikube-zero-install/hello-node
totalSeconds
kubectl get deployments
totalSeconds
kubectl get pods
totalSeconds
kubectl get events
totalSeconds
kubectl expose deployment hello-node --type=LoadBalancer --port=8080
totalSeconds
until [[ "$(kubectl get pod --no-headers -o custom-columns=status:.status.containerStatuses[0].ready)" == 'true' ]]; do
  sleep 10
  echo "Waiting pod."
  set +x
done
set -x
totalSeconds
until [[ "$(kubectl get svc hello-node -o custom-columns=ip:.status.loadBalancer.ingress[0].ip --no-headers)" =~ [0-9]+\.[0-9]+\.[0-9]+\.[0-9]+ ]]; do
  sleep 10
  echo "Waiting svc."
  set +x
done
set -x
totalSeconds
{ set +x; } 2>/dev/null
echo "curl http://$(kubectl get svc hello-node -o 'custom-columns=ip:.status.loadBalancer.ingress[0].ip' --no-headers):8080"
curl "http://$(kubectl get svc hello-node -o 'custom-columns=ip:.status.loadBalancer.ingress[0].ip' --no-headers):8080"