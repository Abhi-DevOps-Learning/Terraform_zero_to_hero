Terraform Project:

Overview
This project sets up an S3 bucket and EC2 instances using Terraform. The configuration for creating the S3 bucket is located in the s3-backend directory, and the configuration for EC2 instances is in the ec2-instance directory. The S3 bucket will be created with a unique name, and the state file for the EC2 instances will be backed up and locked securely.

Prerequisites:

Terraform installed on your machine.
AWS CLI configured with appropriate credentials.
Setup Instructions

1. To Create S3 Bucket
Navigate to the s3-backend directory:

cd your_dir/aws/s3-backend
Initialize Terraform:

Run the following command to initialize Terraform. This command will download the necessary provider plugins.

terraform init
Review the planned changes:

Execute the following command to see what changes Terraform will make. This will show you a preview of the resources that will be created.

terraform plan

Apply the configuration:

Apply the Terraform configuration to create the S3 bucket. This command will execute the planned changes and create the resources.

terraform apply
Confirm the apply action when prompted.

The S3 bucket will be created with a unique name as defined in the main.tf file.

2. Create EC2 Instances
Navigate to the ec2-instance directory:


cd ../ec2-instance
Initialize Terraform with Backend Configuration:

Run the following command to initialize Terraform with the backend configuration. This will take a backup of your state file and lock it.


terraform init -reconfigure -backend-config=../../config/backend-dev.conf

Review the planned changes:

Execute the following command to see what changes Terraform will make. This will show you a preview of the resources that will be created.

terraform plan

Apply the configuration:

Apply the Terraform configuration to create the EC2 instances. This command will execute the planned changes and create the resources.


terraform apply
Confirm the apply action when prompted.

The EC2 instances will be created, and the state file will be stored safely and securely with the provided backend configuration path.



Notes:

Ensure that your AWS credentials have sufficient permissions to create the S3 bucket and EC2 instances.
The terraform apply command will create resources as defined in the main.tf files.
Cleanup
To delete the created resources and remove the state files, run:

terraform destroy
This will prompt for confirmation before deleting the resources.
