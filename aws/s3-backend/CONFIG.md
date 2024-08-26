```terraform
# main.tf
terraform {
  backend "s3" {
    encrypt = true
  }
}

# example of 'partial configuration':
# https://www.terraform.io/docs/backends/config.html#partial-configuration
# Create both the .conf and .tfvars file under the config folder
# cat config/backend-dev.conf
bucket  = "<account_id>-terraform-states"
key     = "development/ec2-service.tfstate"
encrypt = true
region  = "us-east-1"
dynamodb_table = "terraform-lock"
```

```bash
You can make a config/dev.tfvars file as below

# Example of variables you might need to define
aws_region     = "us-east-1" (Choose region of your choice)
project_name   = "ec2-service" (Give the meaningful name for which searvice you want to store state file, the name you can as same you provide in the key in the backend-dev.conf file)
environment    = "development" (For good practices we maintain this as per environments we can maintain this files like dev, stage, preprod, prod etc.)

```
> **NOTE**: Below will be your flow you need to follow.
```bash
you first need to run below commands to create a S3 bucket with DynamoDB.
terramform init
terraform plan
terraform apply
after this your bucket will be created to store your state files and DyanmoDB for locking mechanism. Once,this is done add the backed 's3' to your main.tf file as mentiond in top of this file and then run the below coomands metioned
```
```bash
Below are the commands you need to run:
env=dev
terraform get -update=true
terraform init -backend-config=config/backend-${env}.conf
terraform plan -var-file=config/${env}.tfvars
terraform apply -var-file=config/${env}.tfvars
```


