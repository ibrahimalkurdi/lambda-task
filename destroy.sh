#!/bin/bash

set -e

# Source the AWS Keys and init-config:
source .aws-credentails
source config.sh

cd terraform
terraform init \
-backend-config="bucket=$TF_VAR_state_bucket" \
-backend-config="key=terraform/$TF_VAR_project_name"

terraform destroy
