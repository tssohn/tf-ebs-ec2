# Grab a recent Amazon Linux 2 AMI (x86_64, HVM, EBS-backed)
data "aws_ami" "amzn2" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Security Group: allow SSH from anywhere (lab/demo) and all egress
resource "aws_security_group" "instance" {
  name        = "${var.name_prefix}-sg"
  description = "Allow SSH and all egress for demo"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from anywhere (IPv4)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-sg"
  }
}

# EC2 instance in the specified subnet (t3.micro)
resource "aws_instance" "this" {
  ami                         = data.aws_ami.amzn2.id
  instance_type               = "t3.micro"
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.instance.id]
  associate_public_ip_address = true

  tags = {
    Name = "${var.name_prefix}-ec2"
  }
}

# 1 GiB EBS volume in the SAME AZ as the instance (derive AZ from the instance)
resource "aws_ebs_volume" "extra" {
  availability_zone = aws_instance.this.availability_zone
  size              = 1
  type              = "gp3"

  tags = {
    Name = "${var.name_prefix}-data"
  }
}

# Attach the EBS volume to the instance
resource "aws_volume_attachment" "attach" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.extra.id
  instance_id = aws_instance.this.id
}
