terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"  # Use the latest version that suits your needs
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_vpc" "default" {
  default = true
}

# Generate a TLS private key for SSH access
resource "tls_private_key" "depi_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Security Group Configuration
resource "aws_security_group" "depi_security_group" {
  vpc_id = data.aws_vpc.default.id
  name   = "DEPI-SecurityGroup"

  ingress {
    # Allow SSH access
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    # Allow email notifications (not used in the project)
    from_port   = 25
    to_port     = 25
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    # Allow application traffic (3000-10000)
    from_port   = 3000
    to_port     = 10000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    # Allow HTTP traffic
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    # Allow HTTPS traffic
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    # Required for Kubernetes cluster setup
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    # Allow email notifications from Jenkins (if needed)
    from_port   = 465
    to_port     = 465
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    # Allow application deployment traffic (30000-32767)
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    # Allow all outbound traffic
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instances Configuration
resource "aws_instance" "master" {
  ami           = "ami-0866a3c8686eaeeba"  # Replace with your desired AMI
  instance_type = "t2.micro"
  key_name      = aws_key_pair.depi_key_pair.key_name
  tags = {
    Name = "Master"
  }
}

resource "aws_instance" "slave_01" {
  ami           = "ami-0866a3c8686eaeeba"  # Replace with your desired AMI
  instance_type = "t2.micro"
  key_name      = aws_key_pair.depi_key_pair.key_name
  tags = {
    Name = "Slave-01"
  }
}

resource "aws_instance" "slave_02" {
  ami           = "ami-0866a3c8686eaeeba"  # Replace with your desired AMI
  instance_type = "t2.micro"
  key_name      = aws_key_pair.depi_key_pair.key_name
  tags = {
    Name = "Slave-02"
  }
}

resource "aws_instance" "monitoring" {
  ami           = "ami-0866a3c8686eaeeba"  # Replace with your desired AMI
  instance_type = "t2.micro"
  key_name      = aws_key_pair.depi_key_pair.key_name
  tags = {
    Name = "Monitoring"
  }
}
