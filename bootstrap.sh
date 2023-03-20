#!/bin/bash

set -e

echo "[INFO] Check the project requirments ...."

# Ensure you have aws-cli and terraform binary exists:
if ! command -v aws &> /dev/null; then
	echo "[ERROR] Ensure you have installed "aws-cli" on your machine!"
	return 1
fi

if ! command -v terraform &> /dev/null; then
	echo "[ERROR] Ensure you have installed "terraform" on your machine!"
	return 1
fi

# Source the AWS Keys and init-config:
source .aws-credentails
source config.sh

# Ensure the Terraform backend S3 Bucket is created
if [[ $(aws s3api head-bucket --bucket "$TF_VAR_state_bucket" 2>/dev/null; echo $?) != 0 ]]; then
	echo "[INFO] The $TF_VAR_state_bucket Bucket is not exists, Let's create it"
	aws s3api create-bucket --bucket $TF_VAR_state_bucket --region us-east-1
	echo "[INFO] It has been created successully!"
fi


echo "[INFO] The setup is ready to be initialized!"
