#!/bin/bash

terraform destroy
aws cloudformation delete-stack --stack-name demo-stack-1
