resource "aws_security_group" "nat" {
  name        = "${var.instance_name}-nat-security-group"
  description = "${var.instance_name}-nat-security-group"
  vpc_id      = data.aws_vpc.vpc.id
  tags = {
    Name = "${var.instance_name}-nat-security-group"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = split(",", var.ssh_allowed_ips)
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [data.aws_vpc.vpc.cidr_block]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

