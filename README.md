# lambda-task
This task is to covert CSV file to JSON by Lambda Function

## Prerequisites
- Ensure **aws-cli** and **terraform** installed on your machine
- Add the needed credentials and configs to the setup as below:

1- Clone the **Lambda-task** repo and create file called "**.aws-credentails**" in the top level directory.

2- Add your AWS Access keys in the .aws-credentails file as below:
```
export AWS_ACCESS_KEY_ID="XXXXXXXXXXXXXXXXXXXX"  # Relplace the placeholder with your Access key
export AWS_SECRET_ACCESS_KEY="XXXXXXXXXXXXXXXXXXXXX"  # Replace the placeholder with your Secret key
```
Note:
The Access Keys must have either Administrotor access or admin access on S3, Lambda and SQS resources.

3- Add the initial config in the **init-config.sh** file
```
export AWS_DEFAULT_REGION="" 		# AWS Region for the created AWS resources
export PROJECT_S3_BUCKET=""		# The S3 bucket were the CSV files stores
export TF_VAR_state_bucket=""		# The bucket were the Terraform state files stores in S3 bucke
export TF_VAR_project_name=""		# Variable of the Project name to be used in the Terraform resources which  will be created.
export TF_VAR_aws_region=""		# Terraform AWS region variable
```
