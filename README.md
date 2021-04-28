# tf_aws_ha_nat_instances

Terraform module for creating AWS high availability NAT instances

- Monitor route tables and failover to other availability zone when having incident. Thanks to [AWSnycast](https://github.com/bobtfish/AWSnycast)
- Apply for any subnets with below tags:

```
"az"        = "<<SUBNET_AVAILABILITY_ZONE>>"
"type"      = "private"
"AWSnycast" = "enabled"
```

## Usage

```
module "base_public_subnets" {
  source = "git::https://github.com/FlintersVN/tf_aws_subnets.git?ref=v0.0.1"

  vpc_id       = "vpc-9ab640fcfsdfds"
  gateway_ids  = ["igw-362ad8fsdf3"]
  subnet_name  = "test"
  subnet_cidrs = "10.23.100.0/24,10.23.101.0/24,10.23.102.0/24,10.23.103.0/24,10.23.104.0/24"
  azs          = "ap-northeast-1a,ap-northeast-1c,ap-northeast-1d"
}

module "base_private_subnets" {
  source = "git::https://github.com/FlintersVN/tf_aws_subnets.git?ref=v0.0.1"

  vpc_id       = "vpc-9ab640fcfsdfds"
  instance_id  = module.nat-instances.instance_ids
  subnet_name  = "test"
  subnet_cidrs = "10.23.100.0/24,10.23.101.0/24,10.23.102.0/24,10.23.103.0/24,10.23.104.0/24"
  azs          = "ap-northeast-1a,ap-northeast-1c,ap-northeast-1d"
  subnet_tags  = {
    "type"      = "private"
    "AWSnycast" = "enabled"
  }
}

module "nat-instances" {
  source = "../modules/vpc/ha_nat"

  instance_name     = "test"
  public_subnet_ids = module.base_public_subnets.subnet_ids
  key_name          = "keyname"
  azs               = "ap-northeast-1a,ap-northeast-1c,ap-northeast-1d"
  ssh_allowed_ips   = "xxx.xxx.xxx.xxx/32"
}

```

## Requirements

No requirements.

## Providers

| Name                                                            | Version |
| --------------------------------------------------------------- | ------- |
| <a name="provider_aws"></a> [aws](#provider_aws)                | n/a     |
| <a name="provider_template"></a> [template](#provider_template) | n/a     |

## Modules

No modules.

## Resources

| Name                                                                                                                                                | Type        |
| --------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [aws_eip.nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip)                                                      | resource    |
| [aws_iam_instance_profile.instance-role-iprofile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource    |
| [aws_iam_role.instance-role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)                                  | resource    |
| [aws_iam_role_policy.instance-role-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy)             | resource    |
| [aws_instance.nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)                                            | resource    |
| [aws_security_group.nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)                                | resource    |
| [aws_ami.ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami)                                                   | data source |
| [aws_iam_policy_document.instance-role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)         | data source |
| [aws_iam_policy_document.instance-role-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)  | data source |
| [aws_region.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region)                                         | data source |
| [aws_subnet.first](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet)                                           | data source |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc)                                                   | data source |
| [template_file.user_data](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file)                                 | data source |

## Inputs

| Name                                                                                                               | Description                                                                                                                  | Type     | Default                                                                                          | Required |
| ------------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------- | -------- | ------------------------------------------------------------------------------------------------ | :------: |
| <a name="input_ami_name_pattern"></a> [ami_name_pattern](#input_ami_name_pattern)                                  | The name filter to use in data.aws_ami                                                                                       | `string` | `"ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"`                                      |    no    |
| <a name="input_ami_publisher"></a> [ami_publisher](#input_ami_publisher)                                           | The AWS account ID of the AMI publisher                                                                                      | `string` | `"099720109477"`                                                                                 |    no    |
| <a name="input_assign_eip_address"></a> [assign_eip_address](#input_assign_eip_address)                            | Assign an Elastic IP address to the instance                                                                                 | `bool`   | `true`                                                                                           |    no    |
| <a name="input_associate_public_ip_address"></a> [associate_public_ip_address](#input_associate_public_ip_address) | Associate a public IP address with the instance                                                                              | `bool`   | `true`                                                                                           |    no    |
| <a name="input_awsnycast_deb_url"></a> [awsnycast_deb_url](#input_awsnycast_deb_url)                               | n/a                                                                                                                          | `string` | `"https://github.com/bobtfish/AWSnycast/releases/download/v0.1.5/awsnycast_0.1.5-425_amd64.deb"` |    no    |
| <a name="input_azs"></a> [azs](#input_azs)                                                                         | Availability Zone the instance is launched in. If not set, will be launched in the first AZ of the region                    | `string` | `"ap-northeast-1a,ap-northeast-1c"`                                                              |    no    |
| <a name="input_cpu_credits"></a> [cpu_credits](#input_cpu_credits)                                                 | Credit option for CPU usage.                                                                                                 | `string` | `"standard"`                                                                                     |    no    |
| <a name="input_delete_on_termination"></a> [delete_on_termination](#input_delete_on_termination)                   | Whether the volume should be destroyed on instance termination                                                               | `bool`   | `true`                                                                                           |    no    |
| <a name="input_disable_api_termination"></a> [disable_api_termination](#input_disable_api_termination)             | Enable EC2 Instance Termination Protection                                                                                   | `bool`   | `false`                                                                                          |    no    |
| <a name="input_ebs_optimized"></a> [ebs_optimized](#input_ebs_optimized)                                           | Launched EC2 instance will be EBS-optimized                                                                                  | `bool`   | `false`                                                                                          |    no    |
| <a name="input_instance_name"></a> [instance_name](#input_instance_name)                                           | Name of the instances                                                                                                        | `string` | `""`                                                                                             |    no    |
| <a name="input_instance_tags"></a> [instance_tags](#input_instance_tags)                                           | A map of tags to add all instances                                                                                           | `map`    | `{}`                                                                                             |    no    |
| <a name="input_instance_type"></a> [instance_type](#input_instance_type)                                           | The type of the instance                                                                                                     | `string` | `"t3.nano"`                                                                                      |    no    |
| <a name="input_ip_instance_tags"></a> [ip_instance_tags](#input_ip_instance_tags)                                  | A map of tags to add elastic ip address                                                                                      | `map`    | `{}`                                                                                             |    no    |
| <a name="input_key_name"></a> [key_name](#input_key_name)                                                          | SSH key pair to be provisioned on the instance                                                                               | `string` | n/a                                                                                              |   yes    |
| <a name="input_monitoring"></a> [monitoring](#input_monitoring)                                                    | Launched EC2 instance will have detailed monitoring enabled                                                                  | `bool`   | `false`                                                                                          |    no    |
| <a name="input_public_subnet_ids"></a> [public_subnet_ids](#input_public_subnet_ids)                               | VPC Subnet IDs the instance is launched in                                                                                   | `any`    | n/a                                                                                              |   yes    |
| <a name="input_region"></a> [region](#input_region)                                                                | AWS Region the instance is launched in                                                                                       | `string` | `"ap-northeast-1"`                                                                               |    no    |
| <a name="input_root_block_device_encrypted"></a> [root_block_device_encrypted](#input_root_block_device_encrypted) | Whether to encrypt the root block device                                                                                     | `bool`   | `false`                                                                                          |    no    |
| <a name="input_root_iops"></a> [root_iops](#input_root_iops)                                                       | Amount of provisioned IOPS. This must be set if root_volume_type is set to `io1`                                             | `number` | `0`                                                                                              |    no    |
| <a name="input_root_volume_size"></a> [root_volume_size](#input_root_volume_size)                                  | Size of the root volume in gigabytes                                                                                         | `number` | `10`                                                                                             |    no    |
| <a name="input_root_volume_type"></a> [root_volume_type](#input_root_volume_type)                                  | Type of root volume. Can be standard, gp2 or io1                                                                             | `string` | `"gp2"`                                                                                          |    no    |
| <a name="input_route_table_identifier"></a> [route_table_identifier](#input_route_table_identifier)                | Indentifier used by AWSnycast route table regexp                                                                             | `string` | `"private"`                                                                                      |    no    |
| <a name="input_source_dest_check"></a> [source_dest_check](#input_source_dest_check)                               | Controls if traffic is routed to the instance when the destination address does not match the instance. Used for NAT or VPNs | `bool`   | `false`                                                                                          |    no    |
| <a name="input_ssh_allowed_ips"></a> [ssh_allowed_ips](#input_ssh_allowed_ips)                                     | List of ip addresses to connect instances via ssh                                                                            | `string` | `"127.0.0.1"`                                                                                    |    no    |
| <a name="input_vpc_security_group_ids"></a> [vpc_security_group_ids](#input_vpc_security_group_ids)                | A list of additional Security Groups                                                                                         | `string` | `""`                                                                                             |    no    |

## Outputs

| Name                                                                                                                 | Description |
| -------------------------------------------------------------------------------------------------------------------- | ----------- |
| <a name="output_instance_ids"></a> [instance_ids](#output_instance_ids)                                              | n/a         |
| <a name="output_instance_role_arn"></a> [instance_role_arn](#output_instance_role_arn)                               | n/a         |
| <a name="output_instance_role_id"></a> [instance_role_id](#output_instance_role_id)                                  | n/a         |
| <a name="output_instance_role_iprofile_arn"></a> [instance_role_iprofile_arn](#output_instance_role_iprofile_arn)    | n/a         |
| <a name="output_instance_role_iprofile_id"></a> [instance_role_iprofile_id](#output_instance_role_iprofile_id)       | n/a         |
| <a name="output_instance_role_iprofile_name"></a> [instance_role_iprofile_name](#output_instance_role_iprofile_name) | n/a         |
| <a name="output_instance_role_name"></a> [instance_role_name](#output_instance_role_name)                            | n/a         |
