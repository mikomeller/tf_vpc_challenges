# creates connectivity rules to allow inbound and outbound access to the EC2 instance.
# for SSH access ingress and internet access in egress.

resource "aws_security_group" "my_public_app_sg" {
  name        = "my_public_app_sg"
  description = "Allow access to this server"
  vpc_id      = aws_vpc.main_vpc.id #data.

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