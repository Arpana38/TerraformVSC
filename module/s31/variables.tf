variable "env" {
    description = "environment name"
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

variable "bucket11_folder" {
    type = list(string)
    description = "list of folders to create"
    default = ["hi/","hello/","hey/","mike/","tom1/","tom2/"]
}

/*variable "canonical_external_account" {
    description = "canonical external account ID for s3 bucket access"
}

variable "canonical_owner_account" {
    description = "canonical owner account ID for s3 bucket access"
}*/

/*variable "bucket11policy" {
    description = "bucket11policy"
}*/

#variable "notification_terra_bucket11_enabled" {
#    description = "environment name"
#    default = false
#}