provider "aws" {
  region = "us-east-1"
  profile = "default"
}

module "sg_module" {
  # sg_name = "sg_ec2_${local.env}"
  source = "./sg_module"
}

module "ec2_module" {
  sg_id = "${module.sg_module.sg_id_output}"
  # ec2_name = "EC2_Instance_${local.env}"
  source = "./ec2_module"
}

locals {
  env = "${terraform.workspace}"
  amiid_env {
    default = "amiid_default"
    staging = "amiid_staging"
    production = "amiid_production"
  }
  amiid = "${lookup(local.amiid_env, local.env)}"
}

output "envspecicoutput_variable" {
  value = "${local.amiid}"
}