
locals {
  root_iops              = var.root_volume_type == "io1" ? var.root_iops : "0"
  root_volume_type       = var.root_volume_type != "" ? var.root_volume_type : data.aws_ami.ami.root_device_type
  nat_sg                 = "${aws_security_group.nat.id},${var.vpc_security_group_ids}"
  vpc_security_group_ids = var.vpc_security_group_ids != "" ? local.nat_sg : aws_security_group.nat.id
  region                 = var.region != "" ? var.region : data.aws_region.default.name
  instance_count         = length(var.public_subnet_ids)
}

data "aws_region" "default" {}

data "aws_ami" "ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["${var.ami_name_pattern}"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["${var.ami_publisher}"]
}

data "aws_subnet" "first" {
  id = "${var.public_subnet_ids[0]}"
}

data "aws_vpc" "vpc" {
  id = data.aws_subnet.first.vpc_id
}

data "template_file" "user_data" {
  template = "${file("${path.module}/nat-user-data.conf.tmpl")}"
  count    = "${local.instance_count}"

  vars = {
    name              = var.instance_name
    azs               = element(split(",", var.azs), count.index)
    vpc_cidr          = data.aws_vpc.vpc.cidr_block
    region            = local.region
    awsnycast_deb_url = var.awsnycast_deb_url
    identifier        = var.route_table_identifier
  }
}

resource "aws_instance" "nat" {

  lifecycle {
    ignore_changes = [root_block_device, user_data, ami]
  }

  count                       = local.instance_count
  ami                         = data.aws_ami.ami.id
  instance_type               = var.instance_type
  subnet_id                   = element(var.public_subnet_ids, count.index)
  availability_zone           = element(split(",", var.azs), count.index)
  associate_public_ip_address = var.associate_public_ip_address
  vpc_security_group_ids      = split(",", local.vpc_security_group_ids)
  key_name                    = var.key_name
  source_dest_check           = var.source_dest_check
  ebs_optimized               = var.ebs_optimized
  disable_api_termination     = var.disable_api_termination
  monitoring                  = var.monitoring
  iam_instance_profile        = aws_iam_instance_profile.instance-role-iprofile.name
  user_data                   = element(data.template_file.user_data.*.rendered, count.index)
  root_block_device {
    volume_type           = local.root_volume_type
    volume_size           = var.root_volume_size
    iops                  = local.root_iops
    delete_on_termination = var.delete_on_termination
    encrypted             = var.root_block_device_encrypted
  }

  credit_specification {
    cpu_credits = var.cpu_credits
  }

  volume_tags = merge(
    {
      "Name" = "${var.instance_name}-${element(split(",", var.azs), count.index)}"
    },
    var.instance_tags,
  )
  tags = merge(
    {
      "Name" = "${var.instance_name}-${element(split(",", var.azs), count.index)}"
    },
    var.instance_tags,
  )
}

resource "aws_eip" "nat" {
  count    = var.associate_public_ip_address && var.assign_eip_address ? local.instance_count : 0
  instance = element(aws_instance.nat.*.id, count.index)
  vpc      = true
  tags = merge(
    {
      "Name" = "${var.instance_name}-${element(split(",", var.azs), count.index)}"
    },
    var.ip_instance_tags,
  )
}
