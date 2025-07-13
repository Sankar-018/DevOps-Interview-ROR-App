#  DevOps Assignment – Deploy Ruby on Rails App on AWS EKS using Terraform

This assignment demonstrates how to deploy a **Ruby on Rails** application using **Docker**, **AWS EKS**, **Terraform**, **RDS**, and **S3**, strictly adhering to **DevOps best practices**.

---

##  Assignment Summary

- Forked and cloned the given GitHub repository locally, built Rails and Nginx Docker images, and pushed them to AWS ECR.

- Created Terraform code (IaC) to provision the full infrastructure on AWS: VPC, subnets, Internet Gateway, NAT Gateway, EKS Cluster, Node Group, RDS (PostgreSQL), S3 Bucket, and required IAM roles.

- Designed the infrastructure with all components in private subnets, placing only the Load Balancer in the public subnet, following AWS best practices.

- Used IRSA (IAM Role for Service Account) to integrate the Rails app with S3 securely without using access keys, and provided RDS credentials through Kubernetes Secrets.

- Created detailed Kubernetes manifest files (*.yaml) including namespace, service account, secrets, deployments, services for both Rails and Nginx to deploy the app on EKS.

- Successfully deployed the app, configured remote Terraform backend using S3, and attached a clear architecture diagram, deployment steps, and screenshots for final documentation.

---

##  Project Structure

DevOps-Interview-ROR-App/
├── docker/
│   ├── app/
│   │   ├── Dockerfile
│   │   └── entrypoint.sh
│   └── nginx/
│       ├── Dockerfile
│       └── default.conf
├── infrastructure/
│   ├── terraform/
│   │   ├── main.tf
│   │   ├── provider.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── terraform.tfvars
│   │   ├── backend.tf          #locking state file in remote backend - AWS S3
│   │   └── modules/
│   │       ├── vpc/
│   │       ├── eks/
│   │       ├── rds/
│   │       └── s3/
│   │       └── IAM/
│   ├── kubernetes-manifests/
│   │   ├── namespace.yaml
│   │   ├── serviceaccount.yaml
│   │   ├── rails-secret.yaml
│   │   ├── rails-deployment.yaml
│   │   ├── rails-service.yaml
│   │   ├── nginx-deployment.yaml
│   │   ├── nginx-service.yaml
│   ├── screenshots/
│   ├── architecture-diagram.png
│   └── README.md

```

---

## ✅ What I Have Done

---

### 1. ✅ Forked and Cloned Repository

```

---

### 2. ✅ Dockerized the App and Built Images

```bash
docker build -t rails-app ./docker/app
docker build -t nginx ./docker/nginx
```

---

### 3. ✅ Created AWS ECR and Pushed Images

```bash
aws ecr create-repository --repository-name rails-app
aws ecr create-repository --repository-name nginx

aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin <aws_account_id>.dkr.ecr.ap-south-1.amazonaws.com

docker tag rails-app:latest <aws_account_id>.dkr.ecr.ap-south-1.amazonaws.com/rails-app:latest
docker push <aws_account_id>.dkr.ecr.ap-south-1.amazonaws.com/rails-app:latest

docker tag nginx:latest <aws_account_id>.dkr.ecr.ap-south-1.amazonaws.com/nginx:latest
docker push <aws_account_id>.dkr.ecr.ap-south-1.amazonaws.com/nginx:latest
```

---

### 4. ✅ Provisioned Infrastructure Using Terraform

```bash
cd infrastructure/terraform
terraform init
terraform plan -var-file="terraform.tfvars"
terraform apply -auto-approve
```

**Provisioned:**
- VPC (public + private subnets)
- EKS Cluster + NodeGroup
- RDS (Postgres)
- S3 bucket
- IAM Roles (for IRSA)
- Security Groups and Routing

---

### 5. ✅ Connected kubectl to EKS

```bash
aws eks update-kubeconfig --region ap-south-1 --name devops-cluster
```

---

### 6. ✅ Created Kubernetes Manifests

Inside `infrastructure/kubernetes-manifests/`:

- `namespace.yaml`
- `rails-secret.yaml`
- `rails-deployment.yaml`
- `rails-service.yaml`
- `nginx-deployment.yaml`
- `nginx-service.yaml`
- `nginx-configmap.yaml`
- `serviceaccount.yaml` (IRSA for S3 access)

---

### 7. ✅ Applied K8s Resources to Cluster

```bash
cd infrastructure/kubernetes-manifests/
kubectl apply -f . --recursive    #It will apply all the k8s manifests
```

---

### 8. ✅ Got LoadBalancer URL and Updated Secret

```bash
kubectl get svc -n devops-ror-app

# Output included ELB DNS
# Added it in `rails-secret.yaml` under `LB_ENDPOINT`
```

```bash
kubectl apply -f rails-secret.yaml
kubectl rollout restart deployment rails-app -n devops-ror-app  
```

---

### 9. ✅ Terraform State File Stored in Remote Backend with DynamoDB Locking

```bash
aws s3api create-bucket \
  --bucket rorapp-terraform-state-devops \
  --region ap-south-1 \
  --create-bucket-configuration LocationConstraint=ap-south-1

  #Created DynamoDB table for state locking:
  aws dynamodb create-table \
  --table-name terraform-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
  --region ap-south-1

  #Configured backend block in Terraform beckend.tf for remote state with locking

```
Migrated local state:
```bash
terraform init

```
---

## 🌐 Accessing the App

Final app is accessible via:
``` 
http://<nginx-loadbalancer-endpoint-url>
```