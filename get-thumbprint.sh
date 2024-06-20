#!/bin/bash

CLUSTER="demo-stack-1-eks-cluster"
aws eks wait cluster-active --name $CLUSTER
OIDC_URL=$(aws eks describe-cluster --name $CLUSTER --query "cluster.identity.oidc.issuer" --output text)
#https://oidc.eks.eu-central-1.amazonaws.com/id/950C7B097AB2FBCDD89EAA7496CE583F
THUMBPRINT=$(echo | openssl s_client -servername $(echo $OIDC_URL | cut -d'/' -f3) -showcerts -connect $(echo $OIDC_URL | cut -d'/' -f3):443 2>/dev/null | openssl x509 -fingerprint -noout | cut -d'=' -f2 | sed 's/://g')
echo $THUMBPRINT
