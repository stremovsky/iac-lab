#!/bin/bash

AWS_ACCOUNT_ID=`aws sts get-caller-identity --query 'Account' --output text`

terraform destroy -var="aws_account_id=$AWS_ACCOUNT_ID"
aws cloudformation delete-stack --stack-name demo-stack-1
