# IAC lab

## Preliminary step: generate SSH key and upload it to AWS
```
ssh-keygen -t rsa -b 4096 -C "awskey" -N "" -f awskey
aws ec2 import-key-pair --key-name "awskey" --public-key-material "$(base64 -i awskey.pub)"

```

## Create cloud formation template
```
aws cloudformation create-stack --stack-name demo-stack-1 --template-body file://infra.yaml --capabilities CAPABILITY_IAM
```

## Update stack
```
aws cloudformation update-stack --stack-name demo-stack-1 --template-body file://infra.yaml --capabilities CAPABILITY_IAM
```

## Remove stack
```
aws cloudformation delete-stack --stack-name demo-stack-1
```

## View EKS cluster
```
aws cloudformation describe-stacks --stack-name demo-stack-1 | jq '.Stacks[0].Outputs'
```
