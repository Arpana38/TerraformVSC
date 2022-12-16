#Common tag 

variable "env" {
    description = "environment name"
}

#variable "project_name" {}

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

variable "ingress_rules_apple" {
  type = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
      description = string
  }))
  default     = []
  description = "hello"
}


variable "ingress_rules_orange" {
  type = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = string
      description = string
  }))
  default     = []
  description = "description"
}

variable "ingress_rules_mango" {
  type = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = string
      description = string
  }))
  default     = []
  description = "description"
}