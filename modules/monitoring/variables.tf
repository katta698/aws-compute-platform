variable "name_prefix" {
  type = string
}

variable "asg_name" {
  type = string
}

variable "alb_arn_suffix" {
  type = string
}

variable "target_group_arn_suffix" {
  type = string
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

variable "tags" {
  type    = map(string)
  default = {}
}
