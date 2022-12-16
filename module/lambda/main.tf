########################################################
####################### lambda210 ######################
resource "aws_lambda_function" "lambda210" {
  count         = var.lambda210_enabled ? 1 : 0
#  filename      = "./module/lambda/file2.zip"
  function_name = "lambda210"
  description   = "lambda210 description"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  memory_size   = 128
  timeout       = 3
  publish       = false
  role          = "arn:aws:iam::409269111861:role/CodeStar-codestar-lambda-Execution"
}
resource "aws_lambda_alias" "lambda210" {
  count            = var.lambda210_enabled ? 1 : 0
  name             = replace(timestamp(),":","")
  description      = "lambda210 alias description"
  function_name    = aws_lambda_function.lambda210[0].arn
  function_version = aws_lambda_function.lambda210[0].version
}
########## Output terra_bucket11 #####
#output "terra_bucket11_arn" {
#    value = aws_s3_bucket.terra_bucket11.arn
#}
########## data source lambda #####
/*data "aws_s3_bucket" "terra_bucket11" {
  bucket = "com.coco.focus.${var.env}.eleven.bucket"
}*/
#com.coco.focus.stage.eleven.bucket
/*resource "aws_lambda_permission" "lambda210" {
  count         = var.lambda210_enabled ? 1 : 0
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda210[0].function_name
  principal     = "s3.amazonaws.com"
  source_arn    = data.aws_s3_bucket.terra_bucket11.arn
#  qualifier     = aws_lambda_alias.test_alias.name
}*/
/*########## bucket 11 SNS ##########
resource "aws_s3_bucket_notification" "terra_bucket11" {
  count = var.notification_terra_bucket11_enabled ? 1 : 0
  bucket = data.aws_s3_bucket.terra_bucket11.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.lambda210[0].arn
    events              = ["s3:ObjectCreated:*"]
  }
#  depends_on = [aws_lambda_permission.bucket11-lambda]
}*/

####################################################################################################################
########## IAM Role Lambda #####
/*
resource "aws_iam_role" "bucket11-lambda" {
  name = "bucket11-lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}
*/
####################################################################################################################
#data "aws_s3_bucket" "terra_bucket11" {
#  bucket = "com.coco.focus.stage.eleven.bucket"
#}
########################################################
################# bucket11-lambda ######################
/*resource "aws_lambda_permission" "bucket11-lambda" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.bucket11-lambda.arn
  principal     = "s3.amazonaws.com"
  source_arn    = data.aws_s3_bucket.terra_bucket11.arn
}
*/
/*output "aws_lambda_permission_bucket11_lambda" {
    value = aws_lambda_permission.bucket11-lambda
}*/

resource "aws_lambda_function" "bucket11-lambda" {
  filename      = "./module/lambda/file2.zip"
  function_name = "bucket11-lambda"
  role          = "arn:aws:iam::409269111861:role/CodeStar-codestar-lambda-Execution"
  handler       = "index.handler"
  runtime       = "java11"
  memory_size   = 128
  publish       = false
  timeout       = 5
}
####################################################################################################################################################################################################################################################################################################################################################################################################################################
##### Budget #################################
resource "aws_budgets_budget" "daily-budget" {
  count             = var.daily-budget-enabled ? 1 : 0
  name              = "Daily-${var.env}"
  budget_type       = "COST"
  limit_amount      = "249.98"
  limit_unit        = "USD"
  time_period_start = "2022-08-22_00:00"
  time_unit         = "DAILY"
  cost_types {
    include_credit             = false
    include_discount           = true
    include_other_subscription = true
    include_recurring          = true
    include_refund             = false
    include_subscription       = true
    include_support            = true
    include_tax                = true
    include_upfront            = true
    use_amortized              = true    
    use_blended                = false
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 120
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_sns_topic_arns  = ["${aws_sns_topic.daily-budget-sns[0].arn}"]
  }
}
##### SNS ####################################
resource "aws_sns_topic" "daily-budget-sns" {
  count           = var.daily-budget-enabled ? 1 : 0
  name            = var.sns-daily-budget
}
##### SNS Policy ####################################
resource "aws_sns_topic_policy" "daily-budget-sns-policy" {
  count           = fileexists("module/lambda/sns.accesspolicy.${var.env}.budget.json") ? 1 : 0
  arn             = aws_sns_topic.daily-budget-sns[0].arn
  policy          = file("module/lambda/sns.accesspolicy.${var.env}.budget.json")
}
##################################################################################################
##########################################  SNS Subcription ######################################
/*resource "aws_sns_topic_subscription" "daily-budget-sns-1" {
#  for_each = toset(var.sns-subscription-email) == true ? 1 : 0
  for_each = toset(var.sns-subscription-email)
  topic_arn = aws_sns_topic.daily-budget-sns[0].arn
  protocol = "email"
  confirmation_timeout_in_minutes = 1
  endpoint_auto_confirms          = false
  endpoint                        = each.value
}
*/