#!/bin/bash

set -e

# CONFIG
AWS_REGION=us-east-1
ECR_REPO_NAME=python-app
EKS_CLUSTER_NAME=my-eks-cluster

# 1. Authenticate with ECR
aws ecr get-login-password --region $AWS_REGION | \
    docker login --username AWS \
    --password-stdin 384981131797.dkr.ecr.$AWS_REGION.amazonaws.com

# 2. Build Docker image
docker build -t $ECR_REPO_NAME .

# 3. Tag the image
docker tag $ECR_REPO_NAME:latest 384981131797.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO_NAME:latest

# 4. Push to ECR
docker push 384981131797.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO_NAME:latest

# 5. Update kubeconfig (only if needed)
# aws eks --region $AWS_REGION update-kubeconfig --name $EKS_CLUSTER_NAME

# 6. Deploy to EKS
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml

# Optional: Get External IP
kubectl get svc python-app-service
