/*resource "aws_iam_role" "bucket11-lambda" {
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
data "aws_s3_bucket" "terra_bucket11" {
  bucket = "com.coco.focus.stage.eleven.bucket"
}

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
  filename      = "file1.zip"
  function_name = "bucket11-lambda"
  role          = "arn:aws:iam::409269111861:role/CodeStar-codestar-lambda-Execution"
  handler       = "index.handler"
  runtime       = "java11"
  memory_size   = 128
  publish       = false
  timeout       = 5
}