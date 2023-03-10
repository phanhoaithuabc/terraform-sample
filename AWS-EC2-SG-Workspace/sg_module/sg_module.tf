variable "vpcid" {
  type = "string"
  default = "vpc-c83nsfmk4"
}

module "shared_vars" {
  source = "../shared_vars"
}

# variable "sg_name" {
#     default = "sg_name_${module.shared_vars.env_suffix}"
# }

resource "aws_security_group" "sg_module_creation" {
  # name = "${var.sg_name}"
  name = "sg_name_${module.shared_vars.env_suffix}"
  description = "sg for ec2 instance"
  vpc_id = "${var.vpcid}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  egress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}

output "sg_id_output" {
  value = "${aws_security_group.terraform_ec2_sg_module.id}"
}