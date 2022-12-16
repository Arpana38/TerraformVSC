##### Cloud Trail Security ###########################################
/*
data "aws_s3_bucket" "cloudtrail-focus-trail" {
  bucket  = "com.charter.focus.focus-${var.acct_short}.devops"
}
*/

resource "aws_cloudtrail" "cloudtrail-focus-trail" {
  name                          = "cloud-trail-auditing"
  is_organization_trail         = false
  s3_bucket_name                = "com.coco.focus.stage.cloudtrail.auditing"
  s3_key_prefix                 = "cloud-trail"
#  kms_key_id                    = "arn:aws:kms:us-east-1:409269111861:key/b22d759b-ffad-4b32-a4b1-3c4df0174d6e"
  enable_log_file_validation    = true
  cloud_watch_logs_group_arn    = "arn:aws:logs:us-east-1:409269111861:log-group:cloudwatch-log-group-cloudtrail-auditing:*"
  cloud_watch_logs_role_arn     = "arn:aws:iam::409269111861:role/service-role/cloud-trail-role-for-cloud-watch-logs_cloudtrail-auditing"
  tags                          = { name = "testing-focus-trail-security","terraform" = true }
  is_multi_region_trail         = true
  include_global_service_events = true

    advanced_event_selector {
    name = "Management events selector"
    
    field_selector {
      field  = "eventCategory"
      equals = ["Management"]
    }

    field_selector {
      field = "readOnly"
      equals = ["false"]
    }
  }

  advanced_event_selector {
    name  = "Data-Events-s3"

    field_selector {
      field = "eventCategory"
      equals = ["Data"]
    }

    field_selector {
      field = "resources.type"
      equals = ["AWS::S3::Object"]                 #log all events
    }
  }
  
  insight_selector {
    insight_type = "ApiCallRateInsight"
  }

  insight_selector {
    insight_type = "ApiErrorRateInsight"
  }
}
/*
##### KMS Security ###################################################

resource "aws_kms_key" "cloudtrail-focus-trail" {
  key_usage                          = "ENCRYPT_DECRYPT"
  description                        = "The key created by CloudTrail to encrypt log files. Created Mon May 09 17:33:07 UTC 2022"
  customer_master_key_spec           = "SYMMETRIC_DEFAULT"
  enable_key_rotation                = false
  multi_region                       = false
  is_enabled                         = true
  policy                             = file("kms-policy-${var.acct_short}-focus-trail.json")
}

resource "aws_kms_alias" "cloudtrail-focus-trail" {
  name           = "alias/cloud-trail"
  target_key_id  = aws_kms_key.cloudtrail-focus-trail.key_id
}

##### Cloud Watch Log Group Security #################################

resource "aws_cloudwatch_log_group" "cloudtrail-focus-trail" {
  name              = "aws-cloudtrail-logs-627359435438-focus-trail"     #"Focus-Trail-${var.acct_short}-cloudwatch-log"
  retention_in_days = 0
}

resource "aws_cloudwatch_log_stream" "cloudtrail-focus-trail" {
  name            = "627359435438_CloudTrail_us-east-1"   #"Focus-Trail-${var.acct_short}-log-stream"
  log_group_name  = aws_cloudwatch_log_group.cloudtrail-focus-trail.name
}

resource "aws_cloudwatch_log_metric_filter" "cloudtrail-focus-trail" {
  name            = "S3-Bucket-Policy-Changes"     #"Focus-Trail-${var.acct_short}-log-filter-s3-bucket-changes"
  pattern         = "{ ($.eventSource = s3.amazonaws.com) && (($.eventName = PutBucketAcl) || ($.eventName = PutBucketPolicy) || ($.eventName = PutBucketCors) || ($.eventName = PutBucketLifecycle) || ($.eventName = PutBucketReplication) || ($.eventName = DeleteBucketPolicy) || ($.eventName = DeleteBucketCors) || ($.eventName = DeleteBucketLifecycle) || ($.eventName = DeleteBucketReplication)) }"
  log_group_name  = aws_cloudwatch_log_group.cloudtrail-focus-trail.name

  metric_transformation {
    namespace = "Security"
    name      = "S3-Bucket-Policy-Changes"      #"Focus-Trail-${var.acct_short}-metric-s3-bucket-changes"
    value     = "1"
    unit      = "None"
  }
}

resource "aws_cloudwatch_metric_alarm" "cloudtrail-focus-trail" {
  alarm_name             = "Security S3 Bucket Policy Changes"        #"Focus-Trail-${var.acct_short}-Alarm-S3-Bucket-Changes"
  alarm_description      = "Monitoring of S3 Bucket Changes"
  namespace              = "Security"
  metric_name            = aws_cloudwatch_log_metric_filter.cloudtrail-focus-trail.name    #S3-Bucket-Policy-Changes
  statistic              = "Sum"
  period                 = "300"
  comparison_operator    = "GreaterThanThreshold"
  threshold              = "0"
  datapoints_to_alarm    = "1"
  evaluation_periods     = "1"
  treat_missing_data     = "missing"
  alarm_actions          = [aws_sns_topic.sns-security.arn]
}

##### Role Policy Cloud Watch Log Group Security #####################
#Role to send CloudTrail events to CloudWatch log

resource "aws_iam_role" "cloudtrail-focus-trail" {
  name         = "CloudTrailRoleForCloudWatchLogs_focus-trail"
  path         = "/service-role/"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {"Service": "cloudtrail.amazonaws.com"},
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "cloudtrail-focus-trail" {
  name         = "CloudTrailPolicyForCloudWatchLogs_focus-trail"
  path         = "/"
  description  = "CloudTrail policy to send logs to CloudWatch Logs"
  policy       = data.aws_iam_policy_document.cloudtrail-focus-trail.json
}

data "aws_iam_policy_document" "cloudtrail-focus-trail" {
  statement {
    sid        = "AWSCloudTrailCreateLogStream"
    effect     = "Allow"
    actions    = ["logs:CreateLogStream"]
    resources  = ["${aws_cloudwatch_log_group.cloudtrail-focus-trail.arn}:*"]
  }
  statement {
    sid        = "AWSCloudTrailPutLogEvents"
    effect     = "Allow"
    actions    = ["logs:PutLogEvents"]
    resources  = ["${aws_cloudwatch_log_group.cloudtrail-focus-trail.arn}:*"]
  }
}

resource "aws_iam_role_policy_attachment" "cloudtrail-focus-trail" {
  role        = aws_iam_role.cloudtrail-focus-trail.name
  policy_arn  = aws_iam_policy.cloudtrail-focus-trail.arn
}

##### SNS Topic Security #############################################

resource "aws_sns_topic" "sns-security" {
  name            = var.sns-topic-security
}

resource "aws_sns_topic_policy" "sns-security" {
  arn             = aws_sns_topic.sns-security.arn
  policy          = file("sns.accesspolicy.${var.acct_short}.sns-security.json")
}​
*/
/*
resource "aws_sns_topic" "cloudtrail-focus-trail" {
  name            = "sns-testing210"
}
#while creating sns the policy will be auto created!!!
*/