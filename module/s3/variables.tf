variable "terra_bucket11_folder" {
    type = list(string)
    description = "list of folders to create"
    default = ["hi/","hello/","hey/"]
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

variable "env" {
    description = "environment name"
}