#variable "terra_bucket11" {
#    description = "bucket arn"
#}

variable "env" {
    description = "environment name"
}

variable "sns-daily-budget" {
    description = "name of sns topic for daily budget"
    default = "null"
}

variable "sns-subscription-email" {
#    type        = list(string)
#    type = list
    description = "name of sns topic for daily budget"
}

variable "notification_terra_bucket11_enabled" {
    description = "environment name"
    default = false
}

variable "lambda210_enabled" {
    description = "lambda210 enable or disable"
    default = false
}

#Variable "lambda210_alias_enabled" {
#    description = "lambda210 enable or disable"
#    default = false
#}

variable "daily-budget-enabled" {
    description = "daily budget enabled or disabled in each AWS account"
    default = "false"
}