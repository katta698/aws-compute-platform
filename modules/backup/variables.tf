variable "name_prefix" {
  type = string
}

variable "backup_schedule" {
  type    = string
  default = "cron(0 5 * * ? *)"
}

variable "delete_after_days" {
  type    = number
  default = 7
}

variable "tags" {
  type    = map(string)
  default = {}
}
