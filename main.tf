module "s3" {
    source = "./module/s3"

    env = var.env
#    notification_terra_bucket11_enabled = var.notification_terra_bucket11_enabled
}

module "lambda" {
    source = "./module/lambda"
    
    env = var.env
    notification_terra_bucket11_enabled = var.notification_terra_bucket11_enabled
    lambda210_enabled                   = var.lambda210_enabled
#    lambda210_alias_enabled             = var.lambda210_alias_enabled
}

output "Hello" {
    value = "Hello"
}