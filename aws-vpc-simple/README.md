Docs: https://www.terraform.io/
Install: https://learn.hashicorp.com/tutorials/terraform/install-cli

# Terraform ?

- **Infrastructure as code**
- Ex: Set up VPC for 3 ENV **dev**, **staging** and **production**.
- ![Virtual Private Cloud](https://cloudacademy.com/wp-content/uploads/2016/02/nat-gateway.png)

# Các lệnh thường dùng:

- terraform init (Download module and Library)
- terraform fmt --recursive (Format code)
- terraform plan
- terraform apply

# Các tính năng chính nên quan tâm (Từ docs)

- Command CLI (https://www.terraform.io/cli/commands)
- Syntax create resources (https://www.terraform.io/language/resources/syntax)
- Varriable and data (https://www.terraform.io/language/data-sources https://www.terraform.io/language/values/variables)
- Module (https://www.terraform.io/language/modules/syntax)

# Kinh nghiệm

- Mặc định Terraform sẽ tạo ra file trạng thái resources khi thực thi ở local. Chúng ta nên sử dụng S3 để lưu trạng thái để có thể quản lý phiên bản và chia sẻ với nhiều người trong team.
- Nên tổ chức dưới dạng modules để dễ quản lý. Nhóm các resources lại với nhau.
- Hạn chế việc chỉnh sửa thủ công trên Console để tránh xung đột với Terraform.
- Trường hợp resources đã tồn tại, có thể sử dụng import state từ local để không cần phải tạo lại. (Có thể dùng tool https://github.com/GoogleCloudPlatform/terraformer để tạo Terraform definition code)
- Naming convention, resources dùng **kebab-case**, variable dùng **snake_case**

## Prepare

```hcl
export TF_S3_BACKEND_BUCKET="$(aws sts get-caller-identity --query Account --output text)-tycloud-terraform"
export REGION=ap-southeast-1
export STAGE="dev"
aws s3 mb s3://${TF_S3_BACKEND_BUCKET} --region ${REGION}
terraform init -backend-config "bucket=${TF_S3_BACKEND_BUCKET}" -backend-config "key=${STAGE}/terraform.tfstate" -backend-config "region=${REGION}"
```

## Create resources

```hcl
terraform plan -var-file=${TF_VAR_FILE:-$STAGE.tfvars} -out=${STAGE}.tfplan
terraform apply -input=false ${TF_VAR_FILE:-$STAGE}.tfplan
```

## Delete resources

```hcl
terraform plan -destroy -var-file=${TF_VAR_FILE:-$STAGE.tfvars} -out=${STAGE}.tfplan
terraform apply -destroy -input=false ${TF_VAR_FILE:-$STAGE}.tfplan
```

## References

https://cloudacademy.com/blog/managed-nat-gateway-aws/