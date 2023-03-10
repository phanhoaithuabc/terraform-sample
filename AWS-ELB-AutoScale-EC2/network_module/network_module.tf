module "shared_vars" {
  source = "../shared_vars"
}

resource "aws_security_group" "publicsg" {
  name = "publicsg_${module.shared_vars.env_suffix}"
  description = "public sg for ELB"
  vpc_id = "${module.shared_vars.vpcid}"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  egress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}

resource "aws_security_group" "privatesg" {
  name = "privatesg_${module.shared_vars.env_suffix}"
  description = "private sg for ec2"
  vpc_id = "${module.shared_vars.vpcid}"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = ["${aws_security_group.publicsg.id}"]
  }

  egress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}

output publicsg_id {
  value = "${aws_security_group.publicsg.id}"
}

output privatesg_id {
  value = "${aws_security_group.privatesg.id}"
}