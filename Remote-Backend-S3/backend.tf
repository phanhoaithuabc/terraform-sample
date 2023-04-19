terraform {
    backend "s3" {
        bucket = "terraform-backend-bucket"
        key = "<Path To Your terraform.tfstate file>" # terraform/terraform.tfstate
        region = "us-east-1"
    }
}