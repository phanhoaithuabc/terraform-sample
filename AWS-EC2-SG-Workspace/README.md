Docs: https://www.terraform.io/
Install: https://learn.hashicorp.com/tutorials/terraform/install-cli

# Create a simpe terraform template to launch an instance in the security group
> Use workspace to separate the environment **dev**, **staging**, **production**
```bash
terraform workspace create staging
terraform workspace select staging
```
## Command:

- terraform init
- terraform fmt --recursive (Format code)
- terraform plan
- terraform apply
