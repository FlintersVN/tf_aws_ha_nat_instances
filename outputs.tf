output "instance_ids" {
  value = aws_instance.nat.*.id
}

output "instance_role_iprofile_name" {
  value = ["${aws_iam_instance_profile.instance-role-iprofile.name}"]
}

output "instance_role_name" {
  value = ["${aws_iam_role.instance-role.name}"]
}

output "instance_role_iprofile_arn" {
  value = ["${aws_iam_instance_profile.instance-role-iprofile.arn}"]
}

output "instance_role_arn" {
  value = ["${aws_iam_role.instance-role.arn}"]
}

output "instance_role_iprofile_id" {
  value = ["${aws_iam_instance_profile.instance-role-iprofile.id}"]
}

output "instance_role_id" {
  value = ["${aws_iam_role.instance-role.id}"]
}
