variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  type    = string
  default = "aws-compute-platform"
}

variable "environment" {
  type = string
}

variable "name_prefix" {
  type = string
}

variable "owner" {
  type    = string
  default = "jay"
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_app_subnet_cidrs" {
  type = list(string)
}

variable "azs" {
  type = list(string)
}

variable "enable_nat_gateway" {
  type    = bool
  default = true
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "app_port" {
  type    = number
  default = 8080
}

variable "root_volume_size" {
  type    = number
  default = 20
}

variable "data_volume_size" {
  type    = number
  default = 50
}

variable "desired_capacity" {
  type    = number
  default = 2
}

variable "min_size" {
  type    = number
  default = 2
}

variable "max_size" {
  type    = number
  default = 4
}

variable "cpu_target_value" {
  type    = number
  default = 60
}

variable "enable_deletion_protection" {
  type    = bool
  default = false
}

variable "sns_email" {
  type    = string
  default = ""
}

variable "cpu_alarm_threshold" {
  type    = number
  default = 80
}

variable "log_retention_days" {
  type    = number
  default = 14
}

variable "backup_schedule" {
  type    = string
  default = "cron(0 5 * * ? *)"
}

variable "backup_delete_after_days" {
  type    = number
  default = 7
}
