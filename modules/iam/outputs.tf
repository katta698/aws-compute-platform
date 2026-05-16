output "ec2_instance_profile_name" { value = aws_iam_instance_profile.this.name }
output "ec2_role_name" { value = aws_iam_role.ec2_role.name }
output "app_admins_group_name" { value = aws_iam_group.app_admins.name }
output "app_readonly_group_name" { value = aws_iam_group.app_readonly.name }
