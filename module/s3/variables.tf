variable "env" {
    description = "environment name"
}

variable "zone_name" {
    description = "Name of the Hosted Zone Domain Name in Route53"
    default     = null
}

variable "automation-bucket-folder" {
    type = list(string)
    description = "Name of folders in automation result bucket"
    default = ["automationresult/"]
}