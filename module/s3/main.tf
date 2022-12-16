############ automation result bucket ##############
resource "aws_s3_bucket" "automation-bucket" {
  bucket = "com.coco.focus.${var.env}.automation.result"
  tags = {name = "automation-result-bucket","terraform" = true}
}
########## automation result bucket folder creation ##############
resource "aws_s3_object" "automation-bucket" {
  for_each = toset(var.automation-bucket-folder)
  bucket = aws_s3_bucket.automation-bucket.id
  acl = "private"
  key = each.key  #folder and name of the file in s3
#  source = "./module/s3/index1.txt" 
#path to source/file which will be read.Data inside it will be uploaded/inserted in key path.
}
########## automation result bucket Versioning ##########
resource "aws_s3_bucket_versioning" "automation-bucket" {
  bucket = aws_s3_bucket.automation-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
############# automation result bucket static web hosting enabled #######
resource "aws_s3_bucket_website_configuration" "automation-bucket" {
  bucket = aws_s3_bucket.automation-bucket.id
  index_document {
    suffix = "home.html"
  }
  error_document {
    key = "error1.jpg"
  }
}
########## automation result bucket public access block ########## 
resource "aws_s3_bucket_public_access_block" "automation-bucket" {
  bucket = aws_s3_bucket.automation-bucket.id

  block_public_acls       = true      #1
  ignore_public_acls      = true      #2
  block_public_policy     = true      #3     #if only one of them is false, block all public access status is OFF. 
  restrict_public_buckets = true      #4     #if all of them is true, block all public access status if ON. 
}
/*
########## automation result bucket public access block ########## 
resource "aws_s3_bucket_policy" "automation-bucket" {
  count  = fileexists ("module/s3/com.coco.focus.${var.env}.automation.result.bucketpolicy.json") ? 1 : 0
  # Update policy Cloudfront OAI manually,after Cloudfront OAI creation.
  bucket = aws_s3_bucket.automation-bucket.id
  policy = file ("module/s3/com.coco.focus.stage.automation.result.bucketpolicy.json")
}
*/
########## automation result bucket object ownership ##########
resource "aws_s3_bucket_ownership_controls" "automation-bucket" {
  bucket = aws_s3_bucket.automation-bucket.id
  rule {
    object_ownership = "BucketOwnerEnforced"  #ObjectWriter #BucketOwnerEnforced #BucketOwnerPreferred
  }
}
########## automation result bucket WAF########################
### IP SET ###
resource "aws_wafv2_ip_set" "automation-bucket" {
  name               = "Allowed-IP"
  description        = "Allows IPs in IP Sets and blocks all IPs"
  scope              = "CLOUDFRONT"
  ip_address_version = "IPV4"
  addresses          = ["10.0.1.0/24", "192.0.2.44/32"]
}

###Master####
#########################
### WAF Web ACLs TEST ###
resource "aws_wafv2_web_acl" "automation-bucket-master" {
  name        = "WAF-master"
  description = "master"
  scope       = "CLOUDFRONT"

  default_action {
    block{}
  }
  
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "WAF-master-first"
    sampled_requests_enabled   = true
  }

  rule {
    name     = "rule-builder-master"
    priority = 0

    action {
      allow {}
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.automation-bucket.arn
      }
    }
    
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "rule-builder-master-second"
      sampled_requests_enabled   = true
    }
  }
}
###############################################################

########## AWS Certificate Manager ARN ########################

data "aws_acm_certificate" "issued" {
  domain      = "bisanranjit.com"
  types       = ["AMAZON_ISSUED"]
  statuses    = ["ISSUED"]
  most_recent = true
}
##### CloudFront Cache Policy ID Automation Result Bucket ############
data "aws_cloudfront_cache_policy" "automation-bucket" {
  name = "Managed-CachingOptimized"
}
########## automation result bucket Cloud Front ###############
resource "aws_cloudfront_distribution" "automation-bucket" {
  origin {
    domain_name         = aws_s3_bucket.automation-bucket.bucket_regional_domain_name
    origin_id           = aws_s3_bucket.automation-bucket.bucket_regional_domain_name
    connection_attempts = 3 
    connection_timeout  = 10 
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.automation-bucket.cloudfront_access_identity_path
      }
  }
  ### DEFAULT CACHE BEHAVIOUR
  default_cache_behavior {
    cache_policy_id        = data.aws_cloudfront_cache_policy.automation-bucket.id
    compress               = true                      ### compress objects automatically NO
    viewer_protocol_policy = "redirect-to-https"       #HTTP and HTTPS
    allowed_methods        = ["GET", "HEAD"]           #viewer protocol policy
    cached_methods         = ["GET", "HEAD"]
    #Cache policy and origin request policy config separate resource for this
    ##Cache Key and Origin requests     >>>CachingOptimized= Recommended for s3 Origins
    smooth_streaming          = true
    field_level_encryption_id = ""
    realtime_log_config_arn   = ""
    default_ttl      = 0
    max_ttl          = 0
    min_ttl          = 0
    target_origin_id = aws_s3_bucket.automation-bucket.bucket_regional_domain_name
#    forwarded_values {
#      query_string = false
#      cookies {
#        forward = "none"
#      }
#    }
  }
  # SETTINGS
  price_class         = "PriceClass_100"
#  web_acl_id          = "arn:aws:wafv2:us-east-1:409269111861:global/webacl/waf-v1/17a4b436-b4f5-4c7b-9fe8-e5bc4fe992a4"
#  web_acl_id          = aws_wafv2_web_acl.automation-bucket-master.arn
  #CNAME config here
  #SSLCertificate config here
  aliases             = ["www.bisanranjit.com"] 
  http_version        = "http2"
  default_root_object = "home.html"
  is_ipv6_enabled     = true
  comment             = "final1-static"   #description
  
  enabled             = true
  retain_on_delete    = false     #optional
  wait_for_deployment = true      #optional
  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
#    acm_certificate_arn            = "arn:aws:acm:us-east-1:409269111861:certificate/dec98655-a5f8-4854-8419-32bfecef0bdf"
    acm_certificate_arn            = data.aws_acm_certificate.issued.arn
    cloudfront_default_certificate = false
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }
}
############## Origin Access Identify ##########################
resource "aws_cloudfront_origin_access_identity" "automation-bucket" {
  comment                         = "origin-OAI"
}
########## bucket policy automation result bucket ##############
resource "aws_s3_bucket_policy" "automation-bucket" {
  #count  = fileexists ("module/s3/com.coco.focus.${var.env}.automation.result.bucketpolicy.json") ? 1 : 0
  # Update policy Cloudfront OAI manually,after Cloudfront OAI creation.
  bucket = aws_s3_bucket.automation-bucket.id
  policy = data.aws_iam_policy_document.automation-bucket.json
}

data "aws_iam_policy_document" "automation-bucket" {
  statement {
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.automation-bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.automation-bucket.iam_arn]
    }
  }
}

##### Route 53 Hosted Zone Name ################################

data "aws_route53_zone" "automation-bucket" {
  name         = var.zone_name
  private_zone = false
}

##### Route53 Record Automation Result Bucket ##################

resource "aws_route53_record" "automation-bucket" {
  zone_id = data.aws_route53_zone.automation-bucket.zone_id
  name    = "www.${data.aws_route53_zone.automation-bucket.name}"
  type    = "A"
  
  alias {
    name                   = aws_cloudfront_distribution.automation-bucket.domain_name
    zone_id                = aws_cloudfront_distribution.automation-bucket.hosted_zone_id
    evaluate_target_health = false
  }
}









/*
############## Cache Policy ####################################
resource "aws_cloudfront_cache_policy" "automation-bucket" {
  name        = "automation-bucket-Managed-CachingOptimized"
  comment     = "Default policy when CF compression is enabled"
  default_ttl = 86400
  max_ttl     = 31536000
  min_ttl     = 1
  parameters_in_cache_key_and_forwarded_to_origin {
    enable_accept_encoding_brotli = true
    enable_accept_encoding_gzip   = true
    cookies_config {
      cookie_behavior = "none"
    }
    headers_config {
      header_behavior = "none"
    }
    query_strings_config {
      query_string_behavior = "none"
    }
  }
}
*/



/*
############## Origin Access Identify ##########################
resource "aws_cloudfront_origin_request_policy" "automation-bucket" {
  name    = "example-policy"
  comment = "access-identity-com.coco.focus.stage.automation.result.s3.us-east-1.amazonaws.com"
  cookies_config {
    cookie_behavior = "whitelist"
    cookies {
      items = ["example"]
    }
  }
  headers_config {
    header_behavior = "whitelist"
    headers {
      items = ["example"]
    }
  }
  query_strings_config {
    query_string_behavior = "whitelist"
    query_strings {
      items = ["example"]
    }
  }
}
#origin access identity and yes, update bucket policy
#update bucket policy yes
*/





#    forwarded_values {
#      query_string = false
#      cookies {
#        forward = "none"
#      }
#    }