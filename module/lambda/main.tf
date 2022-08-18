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
data "aws_s3_bucket" "terra_bucket11" {
  bucket = "com.coco.focus.${var.env}.eleven.bucket"
}
#com.coco.focus.stage.eleven.bucket
resource "aws_lambda_permission" "lambda210" {
  count         = var.lambda210_enabled ? 1 : 0
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda210[0].function_name
  principal     = "s3.amazonaws.com"
  source_arn    = data.aws_s3_bucket.terra_bucket11.arn
#  qualifier     = aws_lambda_alias.test_alias.name
}
########## bucket 11 SNS ##########
resource "aws_s3_bucket_notification" "terra_bucket11" {
  count = var.notification_terra_bucket11_enabled ? 1 : 0
  bucket = data.aws_s3_bucket.terra_bucket11.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.lambda210[0].arn
    events              = ["s3:ObjectCreated:*"]
  }
#  depends_on = [aws_lambda_permission.bucket11-lambda]
}


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
resource "aws_lambda_permission" "bucket11-lambda" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.bucket11-lambda.arn
  principal     = "s3.amazonaws.com"
  source_arn    = data.aws_s3_bucket.terra_bucket11.arn
}

output "aws_lambda_permission_bucket11_lambda" {
    value = aws_lambda_permission.bucket11-lambda
}

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

###############################################################################################
########################################### Budget  ###########################################
resource "aws_budgets_budget" "budget-one" {
  name              = "budget-reporting1"
  budget_type       = "COST"
  limit_amount      = "12"
  limit_unit        = "USD"
  time_period_end   = "2087-06-15_00:00"
  time_period_start = "2022-08-01_00:00"
  time_unit         = "MONTHLY"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 120
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = ["ranjitbisan08@gmail.com"]
    subscriber_sns_topic_arns  = ["arn:aws:sns:us-east-1:409269111861:sns-fifo-budget-reporting1"]
  }
}
###############################################################################################
############################################# SNS #############################################
resource "aws_sns_topic" "sns-topic-budget-reporting1" {
  name            = "sns-fifo-budget-reporting1"
  policy          = <<EOF
{
  "Version": "2008-10-17",
  "Id": "__default_policy_ID",
  "Statement": [
    {
      "Sid": "__default_statement_ID1",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": [
        "SNS:GetTopicAttributes",
        "SNS:SetTopicAttributes",
        "SNS:AddPermission",
        "SNS:RemovePermission",
        "SNS:DeleteTopic",
        "SNS:Subscribe",
        "SNS:ListSubscriptionsByTopic",
        "SNS:Publish"
      ],
      "Resource": "arn:aws:sns:us-east-1:409269111861:sns-fifo-budget-reporting1",
      "Condition": {
        "StringEquals": {
          "AWS:SourceOwner": "409269111861"
        }
      }
    },
    {
      "Sid": "AWSBudgets-notification-1",
      "Effect": "Allow",
      "Principal": {
        "Service": "budgets.amazonaws.com"
      },
      "Action": "SNS:Publish",
      "Resource": "arn:aws:sns:us-east-1:409269111861:sns-fifo-budget-reporting1"
    }
  ]
}
EOF
  delivery_policy = <<EOF
{
  "http": {
    "defaultHealthyRetryPolicy": {
      "minDelayTarget": 20,
      "maxDelayTarget": 20,
      "numRetries": 3,
      "numMaxDelayRetries": 0,
      "numNoDelayRetries": 0,
      "numMinDelayRetries": 0,
      "backoffFunction": "linear"
    },
    "disableSubscriptionOverrides": false
  }
}
EOF
}
##################################################################################################
##########################################  SNS Subcription ######################################
resource "aws_sns_topic_subscription" "user_subscription" {
  endpoint = "ranjitbisan08@gmail.com"
  topic_arn = "arn:aws:sns:us-east-1:409269111861:sns-fifo-budget-reporting1"
  protocol = "email"
#  confirmation_timeout_in_minutes = 1
#  endpoint_auto_confirms          = false
}

resource "aws_sns_topic_subscription" "user_subscription2" {
  endpoint = "devops.bisanranjit@gmail.com"
  topic_arn = "arn:aws:sns:us-east-1:409269111861:sns-fifo-budget-reporting1"
  protocol = "email"
#  confirmation_timeout_in_minutes = 1
#  endpoint_auto_confirms          = false
}


#adding this after stash in terra
#new code




#adding new line