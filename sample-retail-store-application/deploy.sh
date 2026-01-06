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

echo "2. Deploying Carts Service..."
kubectl apply -f 08-carts-serviceaccount.yaml
kubectl apply -f 09-carts-configmap.yaml
kubectl apply -f 10-carts-dynamodb-service.yaml
kubectl apply -f 11-carts-service.yaml
kubectl apply -f 12-carts-deployment.yaml
kubectl apply -f 13-carts-dynamodb-deployment.yaml

echo "3. Deploying Orders Service..."
kubectl apply -f 14-orders-serviceaccount.yaml
kubectl apply -f 15-orders-secrets.yaml
kubectl apply -f 16-orders-configmap.yaml
kubectl apply -f 17-orders-postgresql-service.yaml
kubectl apply -f 18-orders-rabbitmq-service.yaml
kubectl apply -f 19-orders-service.yaml
kubectl apply -f 20-orders-deployment.yaml
kubectl apply -f 21-orders-postgresql-statefulset.yaml
kubectl apply -f 22-orders-rabbitmq-statefulset.yaml

echo "4. Deploying Checkout Service..."
kubectl apply -f 23-checkout-serviceaccount.yaml
kubectl apply -f 24-checkout-configmap.yaml
kubectl apply -f 25-checkout-redis-service.yaml
kubectl apply -f 26-checkout-service.yaml
kubectl apply -f 27-checkout-deployment.yaml
kubectl apply -f 28-checkout-redis-deployment.yaml

echo "5. Deploying UI Service..."
kubectl apply -f 29-ui-serviceaccount.yaml
kubectl apply -f 30-ui-configmap.yaml
kubectl apply -f 31-ui-service.yaml
kubectl apply -f 32-ui-deployment.yaml

echo "Deployment complete! Checking status..."
kubectl get pods
kubectl get svc
