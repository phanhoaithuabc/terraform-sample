variable "amiid" {
  default = "ami-3204bb2030c0220sdx2"
}

# output "sharedvar_output_ec2_module" {
#   value = "${module.shared_vars.amiid}"
# }

module "shared_vars" {
  source = "../shared_vars"
}

variable "sg_id" {}
# variable "ec2_name" {
#   default = "EC2_Instance_Name_${module.shared_vars.env_suffix}"
# }

resource "aws_instance" "terraform_ec2_instance" {
  ami = "${var.amiid}"
  instance_type = "t2.micro"
  vpc_security_group_ids = [ "${var.sg_id}" ]
  tags {
    # Name = "${var.ec2_name}"
    Name = "EC2_Instance_Name_${module.shared_vars.env_suffix}"
  }
}