#!/bin/bash

CLUSTER="demo-stack-1-eks-cluster"

if [ ! -e "awskey" ]; then
    echo "create ssh keys"
    ssh-keygen -t rsa -b 4096 -C "awskey" -N "" -f awskey
    aws ec2 import-key-pair --key-name "awskey" --public-key-material "$(base64 -i awskey.pub)"
fi

echo "create stack"
aws cloudformation create-stack --stack-name demo-stack-1 --template-body file://infra.yaml --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM

echo "waiting for cluster to be ready"
sleep 1
aws eks wait cluster-active --name $CLUSTER

echo "update kubernetes configuration"
aws eks update-kubeconfig --name $CLUSTER --region eu-central-1

echo "display cluster info"
kubectl cluster-info

echo "terraform init"
terraform init

echo "terraform apply"
terraform apply

echo "check kubernetes pods"
kubectl get pods
echo "view log with: kubectl logs pod_name"
