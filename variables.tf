variable "instance_type" {
  type        = string
  description = "The type of the instance"
  default     = "t3.nano"
}

variable "instance_name" {
  type        = string
  description = "Name of the instances"
  default     = ""
}

variable "ami_name_pattern" {
  type        = string
  default     = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
  description = "The name filter to use in data.aws_ami"
}

variable "ami_publisher" {
  type        = string
  default     = "099720109477" # Canonical
  description = "The AWS account ID of the AMI publisher"
}

variable "public_subnet_ids" {
  description = "VPC Subnet IDs the instance is launched in"
}

variable "region" {
  type        = string
  description = "AWS Region the instance is launched in"
  default     = "ap-northeast-1"
}

variable "azs" {
  type        = string
  description = "Availability Zone the instance is launched in. If not set, will be launched in the first AZ of the region"
  default     = "ap-northeast-1a,ap-northeast-1c"
}

variable "vpc_security_group_ids" {
  default     = ""
  description = "A list of additional Security Groups"
}

variable "ebs_optimized" {
  type        = bool
  description = "Launched EC2 instance will be EBS-optimized"
  default     = false
}

variable "disable_api_termination" {
  type        = bool
  description = "Enable EC2 Instance Termination Protection"
  default     = false
}

variable "monitoring" {
  type        = bool
  description = "Launched EC2 instance will have detailed monitoring enabled"
  default     = false
}

variable "source_dest_check" {
  type        = bool
  description = "Controls if traffic is routed to the instance when the destination address does not match the instance. Used for NAT or VPNs"
  default     = false
}

variable "root_volume_type" {
  type        = string
  description = "Type of root volume. Can be standard, gp2 or io1"
  default     = "gp2"
}

variable "root_volume_size" {
  type        = number
  description = "Size of the root volume in gigabytes"
  default     = 10
}

variable "root_iops" {
  type        = number
  description = "Amount of provisioned IOPS. This must be set if root_volume_type is set to `io1`"
  default     = 0
}

variable "delete_on_termination" {
  type        = bool
  description = "Whether the volume should be destroyed on instance termination"
  default     = true
}

variable "root_block_device_encrypted" {
  type        = bool
  default     = false
  description = "Whether to encrypt the root block device"
}

variable "associate_public_ip_address" {
  type        = bool
  description = "Associate a public IP address with the instance"
  default     = true
}

variable "assign_eip_address" {
  type        = bool
  description = "Assign an Elastic IP address to the instance"
  default     = true
}

variable "key_name" {
  type        = string
  description = "SSH key pair to be provisioned on the instance"
}

variable "awsnycast_deb_url" {
  default = "https://github.com/bobtfish/AWSnycast/releases/download/v0.1.5/awsnycast_0.1.5-425_amd64.deb"
}

variable "route_table_identifier" {
  description = "Indentifier used by AWSnycast route table regexp"
  default     = "private"
}

variable "cpu_credits" {
  description = "Credit option for CPU usage."
  default     = "standard"
}

variable "instance_tags" {
  description = "A map of tags to add all instances"
  default     = {}
}

variable "ip_instance_tags" {
  description = "A map of tags to add elastic ip address"
  default     = {}
}

variable "ssh_allowed_ips" {
  description = "List of ip addresses to connect instances via ssh"
  default     = "127.0.0.1"
}
