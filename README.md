# lambda-task
This task is to covert CSV file to JSON by Lambda Function

## Prerequisites
To initialize the infrasturcture, add the needed credentials as below:

1- Clone the **Lambda-task** repo and create file called "**aws-credentails**" in the top level directory.
2- Add your AWS Access keys in the aws-credentails as below:
```
export AWS_ACCESS_KEY_ID="XXXXXXXXXXXXXXXXXXXX"  # Relplace the placeholder with your Access key
export AWS_SECRET_ACCESS_KEY="XXXXXXXXXXXXXXXXXXXXX"  # Replace the placeholder with your Secret key
```
Note:
The Access Keys must have either Administrotor access or admin access on S3, Lambda and SQS resources.

