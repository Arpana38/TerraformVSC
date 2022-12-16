terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
#      version = "~> 4.0"
      version = "4.27.0"
    }
  }
}




module "s3" {
    source = "./module/s3"

    env                      = var.env
    automation-bucket-folder = var.automation-bucket-folder
    zone_name                = var.zone_name
#    notification_terra_bucket11_enabled = var.notification_terra_bucket11_enabled
}

module "lambda" {
    source = "./module/lambda"
    
    env = var.env
    notification_terra_bucket11_enabled = var.notification_terra_bucket11_enabled
    lambda210_enabled                   = var.lambda210_enabled
#    lambda210_alias_enabled             = var.lambda210_alias_enabled
    sns-daily-budget                    = var.sns-daily-budget
    sns-subscription-email              = var.sns-subscription-email
    daily-budget-enabled                = var.daily-budget-enabled
}

module "es" {
    source = "./module/es"

    env                      = var.env
}

module "iam" {
    source = "./module/iam"
}

locals {
#  json_data    = jsondecode(file("../../stacks/${var.stack_name}/main.json"))
#  sg_json_data = jsondecode(file("/sg_data/${var.env}_${var.sg_name}_security_group.json"))

  sg_json_data_apple   = jsondecode(file("/sg_data/${var.env}_apple_security_group.json"))
#  abc                  = local.sg_json_data_apple.security_group.name


  sg_json_data_orange  = jsondecode(file("/sg_data/${var.env}_orange_security_group.json"))
  sg_json_data_mango   = jsondecode(file("/sg_data/${var.env}_mango_security_group.json"))
}

#data "terraform_remote_state" "vpc" {
#     backend = "s3"
#  config = {
#    bucket = local.json_data.s3_bucket_name
#    key    = local.json_data.vpc.key
#    region = var.aws_region
#  }
#}

module "sg" {
    source = "./module/sg"
#    count       = fileexists("sg_data/${var.env}_apple_security_group.json") ? 1 : 0

    sg_vpc_id             = var.sg_vpc_id      #data.terraform_remote_state.vpc.outputs.vpc_id    vpc-75d93a08
#    project_name         = local.json_data.project_name
#    ingress_rules        = local.sg_json_data.security_group.ingress_rules
    ingress_rules_apple     = local.sg_json_data_apple.security_group.ingress_rules
#    ingress_rules_apple     =  jsondecode(file("/sg_data/${var.env}_apple_security_group.json")).security_group.ingress_rules
    ingress_rules_orange    = local.sg_json_data_orange.security_group.ingress_rules
    ingress_rules_mango     = local.sg_json_data_mango.security_group.ingress_rules
#    ingress_rules_three     = jsondecode(file("/sg_data/${var.env}_three_security_group.json"))       #can we do this way? why not?
#    ingress_rules        = local.dev_sg_json_data.security_group."${var.env_ingress_rules}"
#    sg_name_one          = var.sg_name_one
#    sg_name_two          = var.sg_name_two
#    sg_name               = var.sg_name
    sg_name_one           = var.sg_name_one
    sg_name_two           = var.sg_name_two
    sg_name_three         = var.sg_name_three
    env                   = var.env
}

module "cloudtrail" {
    source = "./module/cloudtrail"
}

output "Hello" {
    value = "Hello"
}
/*
locals {
#  json_data    = jsondecode(file("../../stacks/${var.stack_name}/main.json"))
#  sg_json_data = jsondecode(file("/sg_data/${var.env}_${var.sg_name}_security_group.json"))
#  sg_json_data_one = jsondecode(file("/sg_data/${var.env}_security_group.json"))
#  sg_json_data_two = jsondecode(file("/sg_data/${var.env}_two_security_group.json"))
#  sg_json_data_three = jsondecode(file("/sg_data/${var.env}_three_security_group.json"))
  sg_json_data_one = jsondecode(file("/sg_data/${var.env}_${var.sg_count}_security_group.json"))
  sg_name          = "${var.sg_name}_${var.sg_count}"
}

module "sg" {
    source = "./module/sg"
    
    sg_vpc_id             = var.sg_vpc_id      #data.terraform_remote_state.vpc.outputs.vpc_id    vpc-75d93a08
#    project_name         = local.json_data.project_name
#    ingress_rules         = local.sg_json_data.security_group.ingress_rules
    ingress_rules           = local.sg_json_data_one.security_group.ingress_rules
#    ingress_rules_two       = local.sg_json_data_two.security_group.ingress_rules
#    ingress_rules_three     = local.sg_json_data_three.security_group.ingress_rules
#    ingress_rules_three     = jsondecode(file("/sg_data/${var.env}_three_security_group.json"))       #can we do this way? why not?
#    ingress_rules        = local.dev_sg_json_data.security_group."${var.env_ingress_rules}"
#    sg_name_one          = var.sg_name_one
#    sg_name_two          = var.sg_name_two
#    sg_name               = var.sg_name
    sg_name               = local.sg_name
#    sg_name_two           = var.sg_name_two
#    sg_name_three         = var.sg_name_three
}
*/

#     Apple     Dev(3) Stage(5) Prod(7)
#     Orange    Dev(5) stage(7)  prod(8)

module "lt-asg" {
    source = "./module/lt-asg"
}

module "ec2" {
    source = "./module/ec2"

    ami_id        = var.ami_id
    instance_type = var.instance_type
}