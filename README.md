# IAC lab

## Preliminary step: generate SSH key and upload it to AWS
```
ssh-keygen -t rsa -b 4096 -C "awskey" -N "" -f awskey
aws ec2 import-key-pair --key-name "awskey" --public-key-material "$(base64 -i awskey.pub)"

```

## Create cloud formation template
```
aws cloudformation create-stack --stack-name demo-stack-1 --template-body file://infra.yaml --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM
```

## Update stack
```
aws cloudformation update-stack --stack-name demo-stack-1 --template-body file://infra.yaml --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM
```

## Remove stack
```
aws cloudformation delete-stack --stack-name demo-stack-1
```

## View EKS cluster
```
aws cloudformation describe-stacks --stack-name demo-stack-1 | jq '.Stacks[0].Outputs'
```

## Gen kubeconfig
```
aws eks update-kubeconfig --name demo-stack-1-eks-cluster --region eu-central-1
kubectl cluster-info
kubectl get pods --all-namespaces
```

## Save python script as configmap
```
kubectl create configmap python-script --from-file=cronjob.py
kubectl describe configmap python-script
kubectl delete configmap python-script
kubectl run my-shell --rm -i --tty --image python:slim -- bash
```
