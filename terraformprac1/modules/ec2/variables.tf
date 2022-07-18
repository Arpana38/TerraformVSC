###ec2 Variables###
variable "region" {
  description = "region for server"
}

#variable "ami" {
#    description = "AMI ID for Server"
#}

variable "instance_type" {
  description = "instance type for Server"
}

variable "server_env" {
  description = "server environment type dev,stage or prod"
}