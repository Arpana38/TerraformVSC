module "s3" {
    source = "./module/s3"

    env = var.env
}

module "lambda" {
    source = "./module/lambda"
}

output "Hello" {
    value = "Hello"
}