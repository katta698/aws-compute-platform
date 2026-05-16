output "alb_dns_name" {
  value = module.compute.alb_dns_name
}

output "application_url" {
  value = "http://${module.compute.alb_dns_name}"
}

output "asg_name" {
  value = module.compute.asg_name
}

output "ec2_instance_profile_name" {
  value = module.iam.ec2_instance_profile_name
}

output "backup_vault_name" {
  value = module.backup.backup_vault_name
}
