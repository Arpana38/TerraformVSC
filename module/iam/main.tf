resource "aws_iam_policy" "cloudtrail-focus-trail" {
  name        = "test-policy-CloudTrailRoleForCloudWatchLogs"
  path        = "/"
  description = "CloudTrail policy to send logs to CloudWatch Logs"
  policy      = data.aws_iam_policy_document.cloudtrail-focus-trail.json
}

data "aws_iam_policy_document" "cloudtrail-focus-trail" {
  statement {
    sid       = "AWSCloudTrailCreateLogStream2014110"
    effect    = "Allow"
    actions   = ["logs:CreateLogStream"]
    resources = ["arn:aws:logs:us-east-1:409269111861:log-group:cloudwatch-log-group-cloudtrail-auditing:*"]
  }
}