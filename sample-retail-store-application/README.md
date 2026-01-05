# Retail Store Sample Application

## Overview
This is a microservices-based e-commerce application designed for EKS troubleshooting and learning scenarios. 
The application demonstrates real-world patterns and common issues encountered in production environments.

## Architecture

### Services
- **UI Service** - Frontend web application (Spring Boot)
- **Catalog Service** - Product catalog management (Spring Boot + MySQL)
- **Carts Service** - Shopping cart functionality (Java + DynamoDB)
- **Orders Service** - Order processing (Java + PostgreSQL + RabbitMQ)
- **Checkout Service** - Payment processing (Node.js + Redis)

### Monitoring Stack
- **Prometheus** - Metrics collection and alerting
- **Grafana** - Visualization and dashboards

## File Structure

### Catalog Service (Files 01-07)
```
01-catalog-serviceaccount.yaml    # RBAC identity for catalog pods
02-catalog-secret.yaml           # Database credentials (base64 encoded)
03-catalog-configmap.yaml        # Database connection configuration
04-catalog-mysql-service.yaml    # MySQL service (port 3306)
05-catalog-service.yaml          # Catalog API service (port 80)
06-catalog-deployment.yaml       # Catalog application deployment
07-catalog-mysql-statefulset.yaml # MySQL database StatefulSet
```

### UI Service (Files 20-23)
```
20-ui-serviceaccount.yaml        # RBAC identity for UI pods
21-ui-configmap.yaml            # Service endpoint configurations
22-ui-service.yaml              # LoadBalancer for external access
23-ui-deployment.yaml           # UI frontend deployment
```

### Monitoring Stack (Files 30-35)
```
30-prometheus-config.yaml       # Prometheus scraping configuration
31-prometheus-deployment.yaml   # Prometheus server deployment
32-prometheus-service.yaml      # Prometheus LoadBalancer service
33-grafana-deployment.yaml      # Grafana visualization deployment
34-grafana-service.yaml         # Grafana LoadBalancer service
35-prometheus-rbac.yaml         # RBAC for Prometheus pod discovery
```

## Service Connections

### Data Flow
```
Internet → LoadBalancer → UI Service → Backend Services → Databases
```

### Internal Communication
```
UI (port 8080) → Catalog Service (port 80) → MySQL (port 3306)
UI (port 8080) → Carts Service (port 80) → DynamoDB (port 8000)
UI (port 8080) → Orders Service (port 80) → PostgreSQL (port 5432)
UI (port 8080) → Checkout Service (port 80) → Redis (port 6379)
```

### Monitoring Flow
```
Prometheus → Scrapes metrics from all services → Grafana visualizes
```

## Key Configuration Points

### Environment Variables (UI ConfigMap)
- `RETAIL_UI_ENDPOINTS_CATALOG: http://catalog` - Catalog service endpoint
- `RETAIL_UI_ENDPOINTS_CARTS: http://carts` - Cart service endpoint
- `RETAIL_UI_ENDPOINTS_CHECKOUT: http://checkout` - Checkout service endpoint
- `RETAIL_UI_ENDPOINTS_ORDERS: http://orders` - Orders service endpoint

### Database Credentials (Catalog Secret)
- Username: `catalog` (base64: Y2F0YWxvZw==)
- Password: `UD07xbLktgOwvXJ2` (base64: VUQwN3hiTGt0Z093dlhKMg==)

### Prometheus Annotations
All services include Prometheus scraping annotations:
```yaml
prometheus.io/scrape: "true"
prometheus.io/port: "8080"
prometheus.io/path: "/metrics" or "/actuator/prometheus"
```

## Deployment

### Quick Start
```bash
# Deploy application only
./deploy-all.sh

# Deploy with monitoring
./deploy-with-monitoring.sh
```

### Manual Deployment
```bash
# 1. Deploy Catalog Service
kubectl apply -f 01-catalog-serviceaccount.yaml
kubectl apply -f 02-catalog-secret.yaml
kubectl apply -f 03-catalog-configmap.yaml
kubectl apply -f 04-catalog-mysql-service.yaml
kubectl apply -f 05-catalog-service.yaml
kubectl apply -f 06-catalog-deployment.yaml
kubectl apply -f 07-catalog-mysql-statefulset.yaml

# 2. Deploy UI Service
kubectl apply -f 20-ui-serviceaccount.yaml
kubectl apply -f 21-ui-configmap.yaml
kubectl apply -f 22-ui-service.yaml
kubectl apply -f 23-ui-deployment.yaml

# 3. Deploy Monitoring (Optional)
kubectl apply -f 30-prometheus-config.yaml
kubectl apply -f 35-prometheus-rbac.yaml
kubectl apply -f 31-prometheus-deployment.yaml
kubectl apply -f 32-prometheus-service.yaml
kubectl apply -f 33-grafana-deployment.yaml
kubectl apply -f 34-grafana-service.yaml
```

## Access Points

### Application
- **UI**: LoadBalancer service on port 80
- **Health Check**: `/actuator/health/readiness`
- **Metrics**: `/actuator/prometheus`

### Monitoring
- **Prometheus**: LoadBalancer service on port 9090
- **Grafana**: LoadBalancer service on port 3000
  - Username: `admin`
  - Password: `admin123`

## Troubleshooting Scenarios

### Common Issues to Simulate
1. **Pod Scheduling Failures**
   - Resource constraints
   - Node affinity mismatches
   - Taints and tolerations

2. **Service Discovery Problems**
   - DNS resolution failures
   - Service endpoint issues
   - Network policies blocking traffic

3. **Database Connection Issues**
   - Secret misconfiguration
   - Service name resolution
   - Port connectivity

4. **Load Balancer Problems**
   - Security group restrictions
   - Target group health checks
   - ALB/NLB provisioning failures

5. **Resource Constraints**
   - Memory/CPU limits
   - Storage issues
   - Node capacity problems

### Diagnostic Commands
```bash
# Check pod status
kubectl get pods -o wide

# Check services and endpoints
kubectl get svc
kubectl get endpoints

# Check events
kubectl get events --sort-by=.metadata.creationTimestamp

# Check logs
kubectl logs -l app.kubernetes.io/name=ui
kubectl logs -l app.kubernetes.io/name=catalog

# Port forward for testing
kubectl port-forward svc/ui 8080:80
kubectl port-forward svc/prometheus 9090:9090
kubectl port-forward svc/grafana 3000:3000
```

## Resource Requirements

### Minimum Cluster Requirements
- **Nodes**: 2 nodes (t3.medium or larger)
- **CPU**: 2 vCPUs total
- **Memory**: 4GB RAM total
- **Storage**: 20GB EBS volumes

### Per Service Resources
- **UI**: 128m CPU, 512Mi memory
- **Catalog**: 256m CPU, 256Mi memory
- **MySQL**: Default limits
- **Prometheus**: 100m CPU, 256Mi memory
- **Grafana**: 100m CPU, 256Mi memory

## Security Features

### Pod Security
- Non-root containers
- Read-only root filesystem
- Dropped capabilities
- Security contexts

### RBAC
- Service accounts for each service
- Minimal required permissions
- Prometheus cluster role for discovery

## Monitoring & Observability

### Metrics Available
- Application metrics (Spring Boot Actuator)
- JVM metrics (heap, GC, threads)
- HTTP request metrics
- Database connection pool metrics
- Custom business metrics

### Health Checks
- Readiness probes on all services
- Liveness probes where applicable
- Dependency health checks

## Use Cases for EKS Support

This application is perfect for simulating:
- Microservices communication issues
- Database connectivity problems
- Load balancer configuration issues
- Resource constraint scenarios
- Monitoring and alerting setup
- Security policy testing
- Network troubleshooting
- Storage and persistence issues
