#!/bin/bash
set -e
echo "Deploying all Kubernetes resources..."

kubectl apply -f .infrastructure/namespace.yml
kubectl apply -f .infrastructure/configMap.yml
kubectl apply -f .infrastructure/secret.yml
kubectl apply -f .infrastructure/pv.yml
kubectl apply -f .infrastructure/pvc.yml
kubectl apply -f .infrastructure/clusterIp.yml
kubectl apply -f .infrastructure/nodePort.yml
kubectl apply -f .infrastructure/deployment.yml
kubectl apply -f .infrastructure/hpa.yml

echo "Deployment complete!"

# Перевірка стану кластера
echo "---"
echo "Checking all Pods:"
kubectl get pods -A

echo "---"
echo "Checking all Services:"
kubectl get svc -A