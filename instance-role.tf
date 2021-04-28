data "aws_iam_policy_document" "instance-role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "instance-role-policy" {
  statement {
    effect = "Allow"

    actions = [
      "ssm:DescribeAssociation",
      "ssm:GetDeployablePatchSnapshotForInstance",
      "ssm:GetDocument",
      "ssm:DescribeDocument",
      "ssm:GetManifest",
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:ListAssociations",
      "ssm:ListInstanceAssociations",
      "ssm:PutInventory",
      "ssm:PutComplianceItems",
      "ssm:PutConfigurePackageResult",
      "ssm:UpdateAssociationStatus",
      "ssm:UpdateInstanceAssociationStatus",
      "ssm:UpdateInstanceInformation"
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "ec2messages:AcknowledgeMessage",
      "ec2messages:DeleteMessage",
      "ec2messages:FailMessage",
      "ec2messages:GetEndpoint",
      "ec2messages:GetMessages",
      "ec2messages:SendReply"
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "logs:DescribeLogGroups",
      "logs:GetLogEvents",
      "logs:PutLogEvents",
      "logs:CreateLogStream",
      "logs:DescribeLogStreams",
      "logs:PutRetentionPolicy",
      "logs:CreateLogGroup"
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "ec2:ReplaceRoute",
      "ec2:CreateRoute",
      "ec2:DeleteRoute",
      "ec2:DescribeRouteTables",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeInstanceAttribute"
    ]

    resources = ["*"]
  }

}

resource "aws_iam_role" "instance-role" {
  name               = "${var.instance_name}-nat-instance-role"
  description        = "${var.instance_name}-nat-instance-role"
  assume_role_policy = data.aws_iam_policy_document.instance-role.json
}

resource "aws_iam_role_policy" "instance-role-policy" {
  name   = "${var.instance_name}-nat-instance-role"
  role   = aws_iam_role.instance-role.id
  policy = data.aws_iam_policy_document.instance-role-policy.json
}

resource "aws_iam_instance_profile" "instance-role-iprofile" {
  name = "${var.instance_name}-nat-instance-role"
  path = "/"
  role = aws_iam_role.instance-role.name
}
