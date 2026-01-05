#!/bin/bash

echo "Deploying Retail Store Application..."

# Deploy in order
echo "1. Deploying Catalog Service..."
kubectl apply -f 01-catalog-serviceaccount.yaml
kubectl apply -f 02-catalog-secret.yaml
kubectl apply -f 03-catalog-configmap.yaml
kubectl apply -f 04-catalog-mysql-service.yaml
kubectl apply -f 05-catalog-service.yaml
kubectl apply -f 06-catalog-deployment.yaml
kubectl apply -f 07-catalog-mysql-statefulset.yaml

echo "2. Deploying UI Service..."
kubectl apply -f 20-ui-serviceaccount.yaml
kubectl apply -f 21-ui-configmap.yaml
kubectl apply -f 22-ui-service.yaml
kubectl apply -f 23-ui-deployment.yaml

echo "Deployment complete! Checking status..."
kubectl get pods
kubectl get svc
