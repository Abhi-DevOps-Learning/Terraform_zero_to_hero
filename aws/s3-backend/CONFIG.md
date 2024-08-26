Add this belwo to your main.tf file under terraform{}

  backend "s3" {
    encrypt = true
  }

# example of 'partial configuration':
# https://www.terraform.io/docs/backends/config.html#partial-configuration
# Create config/backend-dev.conf folder and file and add below all in to the .conf file.
# cat config/backend-dev.conf
bucket  = "<account_id>-terraform-states"
key     = "development/service-name.tfstate"
encrypt = true
region  = "ap-southeast-2"
dynamodb_table = "terraform-lock"
```

> **NOTE**: you'll need a config/dev.tfvars too to set your other environment values.

```bash
env=dev
terraform get -update=true
terraform init -backend-config=config/backend-${env}.conf (adjust the command as per your config folder path)
terraform plan -var-file=config/${env}.tfvars
terraform apply -var-file=config/${env}.tfvars
```
