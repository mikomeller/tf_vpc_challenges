# tf_vpc_challenges

Getting set up
All the example codes can be found here : Traininig EC2 Lab.

Start by exporting the right profile and region to start working with terraform:

export AWS_PROFILE="cloudreach-trainer-lab"
export AWS_DEFAULT_REGION="us-east-1"
Go to GitHub to create a new repository for the EC2 project.

Clone your EC2 repository to start working on the terraform code:

git clone github.com/test/new-EC2-project-folder
cd new-ec2-project-folder
Provider
Start by setting up your provider to define which cloud plugins our project will require to deploy the resources.

Create a new file called provider.tf

provider "aws" {
  region = "us-east-1"
}
Backend
Create a backend.tf file to select your bucket, key and lock table for your project.

terraform {
  backend "s3" {
    bucket = "talent-academy-account_id-tfstates-pascal"
    key    = "projects/ec2/terraform.tfstates"
    dynamodb_table = "terraform-lock"
  }
}
Do not forget to update the key value to keep it separate from other projects.

Data Sources
Create a main.tf file to collect information about existing resources in AWS and be able to use them within the terraform code.

E.G. Collecting the AMI id to be used for the instance creations.

data "aws_ami" "aws_basic_linux" {
  owners      = [var.aws_owner_id]
  most_recent = true
  filter {
    name   = "name"
    values = [var.aws_ami_name]
  }
}
Use this example to create data sources for the following resources:

VPC
Public Subnet
Variables
All variables needs to be defined first before being assigned a value. It's best practice to create a file called variables.tf which will define all the variables.

E.G of variables.tf :

# DEFINING ALL VARIABLES
variable "aws_owner_id" {
  description = "Contains the Owner ID of the ami for amazon linux"
  type        = string
}

variable "aws_ami_name" {
  description = "Name of the ami I want for my project"
  type        = string
}
And use the terraform.tfvars to assign values to your variables:

# ASSIGNING VALUE TO VARIABLES
aws_owner_id       = "137112412989"
aws_ami_name       = "amzn2-ami-kernel-5.10-hvm*"
Security Groups
Create a new file called security_groups.tf that creates connectivity rules to allow inbound and outbound access to the EC2 instance.

E.G. for SSH access ingress and internet access in egress.

resource "aws_security_group" "my_public_app_sg" {
  name        = "my_public_app_sg"
  description = "Allow access to this server"
  vpc_id      = data.aws_vpc.main_vpc.id

  # INBOUND CONNECTIONS
  ingress {
    description = "Allow SSH into the EC2"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # OUTBOUT CONNECTIONS
  egress {
    description = "Allow access to the world"
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # TCP + UDP
    cidr_blocks = ["0.0.0.0/0"]
  }
}
Key Pair
Make sure you have a key pair created in AWS console. The private key needs to exists in your local machines at the default ssh keys location. E.G. key location and changing permission

cat ~/.ssh/aws_keypair
chmod 600 ~/.ssh/aws_keypair
EC2 instances
Create the EC2 instance using all the other data sources and resources:

resource "aws_instance" "my_public_server" {
  ami                    = data.aws_ami.aws_basic_linux.id
  instance_type          = var.ec2_type
  subnet_id              = data.aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.my_public_app_sg.id]
  key_name               = var.my_keypair

  tags = {
      Name = "public_server"
  }
}
Challenge 1
Create an architecture that will host public instance with internet connectivity and allow SSH access from your mac.
Create 3 instances in the private subnet
Set up a new security Group, that allow SSH access ONLY from the public instance to connect to the private IP Address of the private instances.
Attach the new Security Group to the private instances.
Connect to the public instance and paste your private key into the /home/ec2-user/.ssh/. This will allow you to connect to the private instances
Challenge 2 - Bonus
For security and monitoring purposes, the client is requesting a dashboard like interface that list all the running virtual machines that exists in their application(private) subnet.

You have been tasked to create a web server on the public subnet that will provide a list of existing running instances within the private subnet. You can use coding tools like Python(with boto3), bash scripting with awscliv2 or any other tools, to collect the information about the infrastructure.