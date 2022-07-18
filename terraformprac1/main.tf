provider "aws" {
  region = var.region
}

/*
terraform {
    backend "s3" {
        bucket = var.tf_state_bucket
        key    = var.tf_state_key
        region = "us-east-1"
        encrypt = true
    }
}
*/
module "ec2" {
  source = "./modules/ec2"

  region = var.region
  #    ami    = var.instance_type
  instance_type = var.instance_type
  server_env    = var.server_env
}