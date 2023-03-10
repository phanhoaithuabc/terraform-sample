locals {
  env = "${terraform.workspace}"
  vpcid_env {
    default = "vpc-b59454a74"
    staging = "vpc-b59454a74"
    production = "vpc-b59454a74"
  }
  vpcid = "${lookup(local.vpcid_env, local.env)}"

  publicsubnetid1_env {
    default = "subnet-4223473b"
    staging = "subnet-4223473b"
    production = "subnet-4223473b"
  }
  publicsubnetid1 = "${lookup(local.publicsubnetid1_env, local.env)}"

  publicsubnetid2_env {
    default = "subnet-32958235a"
    staging = "subnet-32958235a"
    production = "subnet-32958235a"
  }
  publicsubnetid2 = "${lookup(local.publicsubnetid2_env, local.env)}"

  privatesubnetid_env {
    default = "subnet-38235824a"
    staging = "subnet-38235824a"
    production = "subnet-38235824a"
  }
  privatesubnetid = "${lookup(local.privatesubnetid_env, local.env)}"
}

output "vpcid" {
  value = "${local.vpcid}"
}

output "publicsubnetid1" {
  value = "${local.publicsubnetid1}"
}

output "publicsubnetid2" {
  value = "${local.publicsubnetid2}"
}

output "privatesubnetid" {
  value = "${local.privatesubnetid}"
}

output "env_sufix" {
  value = "${local.env}"
}