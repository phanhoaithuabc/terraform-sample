provider "aws" {
  access_key = "<Your Access Key>"
  secret_key = "<Your Secret Key>"
  region = "us-east-1"
}

resource "aws_instance" "Backend" {
  count = "2"
  ami = "ami-0323c3dd2da7fb37d"
  instance_type = "t2.micro"
}