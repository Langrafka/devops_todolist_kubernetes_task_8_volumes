#!/bin/bash
set -e
echo "Deploying all Kubernetes resources..."

kubectl apply -f namespace.yml
kubectl apply -f configMap.yml
kubectl apply -f secret.yml
kubectl apply -f pv.yml
kubectl apply -f pvc.yml
kubectl apply -f clusterIp.yml
kubectl apply -f nodePort.yml
kubectl apply -f deployment.yml
kubectl apply -f hpa.yml

echo "Deployment complete!"

# Перевірка стану кластера
echo "---"
echo "Checking all Pods:"
kubectl get pods -A

echo "---"
echo "Checking all Services:"
kubectl get svc -A