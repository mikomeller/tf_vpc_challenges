resource "aws_vpc" "main_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  #  availability_zone = "eu-central-1a"
  # filter {
  #   name = "tag:Name"
  #   values = [var.vpc_id]}

  tags = {
    Name = "main_vpc"
  }
}


# https://stackoverflow.com/questions/52074138/how-to-use-the-vpc-id-and-subnets-id-values-which-were-created-from-one-terrafor