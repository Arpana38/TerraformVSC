variable "env" {
    description = "environment name"
}

variable "zone_name" {
    description = "Name of the Hosted Zone Domain Name in Route53"
    default     = null
}

variable "sns-daily-budget" {
    description = "name of sns topic for daily budget"
    default = "null"
}

variable "sns-subscription-email" {
#    type        = list(string)
#    type        = list
    description = "name of sns topic for daily budget"
}

#variable "terra_bucket11" {
#    description = "bucket arn"
#}

variable "notification_terra_bucket11_enabled" {
    description = "environment name"
    default = false
}

variable "lambda210_enabled" {
    description = "lambda210 enable or disable"
    default = false
}

#variable "lambda210_alias_enabled" {
#    description = "lambda210 enable or disable"
#    default = false
#}

variable "daily-budget-enabled" {
    description = "daily budget enabled or disabled in each AWS account"
    default = "false"
}

variable "automation-bucket-folder" {
    type = list(string)
    description = "Name of folders in automation result bucket"
    default = ["automationresult/"]
}
###########################################################################
variable "sg_vpc_id" {
}

#variable "sg_name_one" {
#}

variable "sg_name_one" {
}

variable "sg_name_two" {
}

variable "sg_name_three" {
}