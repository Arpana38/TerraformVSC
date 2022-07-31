######################################################################################################
####################  TERRAFORM SCRIPT TO CREATE S3 BUCKETS FOR THE SIA APPLICATION ##################
######################################################################################################
########## bucket 11 output ##########
output "bucket_arn" {
    value = aws_s3_bucket.terra_bucket11.arn
}
output "bucket_id" {
    value = aws_s3_bucket.terra_bucket11.id
}
########## bucket 11 ##########
resource "aws_s3_bucket" "terra_bucket11" {
  bucket = "com.coco.focus.${var.env}.eleven.bucket"
  tags = {name = "bucket11","terraform" = true}
}
########## data source lambda #####
data "aws_lambda_function" "bucket11-lambda" {
  function_name = "bucket11-lambda"
}

#data "aws_lambda_permission" "bucket11-lambda" {
#  value = "AllowExecutionFromS3Bucket"
#}

#output "aws_lambda_permission_bucket11_lambda" {
#    value = aws_lambda_permission.bucket11-lambda
#}

########## bucket 11 SNS ##########
resource "aws_s3_bucket_notification" "terra_bucket11" {
  bucket = aws_s3_bucket.terra_bucket11.id

  lambda_function {
    lambda_function_arn = data.aws_lambda_function.bucket11-lambda.arn
#    lambda_function_arn = "arn:aws:lambda:us-east-1:409269111861:function:bucket11-lambda"
    events              = ["s3:ObjectCreated:*"]
  }
#  depends_on = [aws_lambda_permission.bucket11-lambda]
}
########## bucket 11 policy ##########

resource "aws_s3_bucket_policy" "terra_bucket11" {
  bucket = aws_s3_bucket.terra_bucket11.id
#  policy = fileexists("module/s3/com.coco.focus.${var.env}.eleven.bucket.json") ? file("module/s3/com.coco.focus.${var.env}.eleven.bucket.json") : 0
  policy = "${file ("module/s3/com.coco.focus.${var.env}.eleven.bucket.json")}"   
  #env=stage(has policy)  #env=prod(no policy) how to use 1:0? create if exist,do not create if not exit.
}

########## bucket 11 Versioning ##########
resource "aws_s3_bucket_versioning" "terra_bucket11" {
  bucket = aws_s3_bucket.terra_bucket11.id
  versioning_configuration {
    status = "Disabled"
  }
}
########## bucket 11 public access block ########## 
resource "aws_s3_bucket_public_access_block" "terra_bucket11" {
  bucket = aws_s3_bucket.terra_bucket11.id

  block_public_acls       = true         #1
  ignore_public_acls      = true          #2
  block_public_policy     = true         #3     #if only one of them is false, block all public access status is OFF. 
  restrict_public_buckets = true         #4     #if all of them is true, block all public access status if ON. 
}
########## bucket 11 object ownership ##########
resource "aws_s3_bucket_ownership_controls" "terra_bucket11" {
  bucket = aws_s3_bucket.terra_bucket11.id
  rule {
    object_ownership = "ObjectWriter"  #BucketOwnerPreferred
  }
}
########## bucket 11 ACL ##########
#what is meant by ACL private?where does the change happen in console?
#note: need to have acl enabled to use this by (resource:bucket_ownership_control) OR, enable ACL manually
resource "aws_s3_bucket_acl" "terra_bucket11" {       
  bucket = aws_s3_bucket.terra_bucket11.id
  acl    = "private"
#  acl    = "authenticated-read"
}
########## bucket 11 lifecycle ##########
resource "aws_s3_bucket_lifecycle_configuration" "terra_bucket11" {
  bucket = aws_s3_bucket.terra_bucket11.id
  rule {
    id = "bucket11lifecycle"
    status = "Enabled"
    abort_incomplete_multipart_upload {
      days_after_initiation = 2
    }
    expiration {
      days = 3
      expired_object_delete_marker = false
      
    }
  }
}
########## bucket 11 folder creation ##########
/*
resource "aws_s3_object" "terra_bucket11" {
    for_each = toset(var.terra_bucket11_folder)
    bucket = aws_s3_bucket.terra_bucket11.id
    acl = "private"
    key = each.key
    source = "null"
}
*/
########## bucket 11 encryption ##########
/*
resource "aws_s3_bucket_server_side_encryption_configuration" "terra_bucket11" {
  bucket = aws_s3_bucket.terra_bucket11.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}*/
######### bucket 11 ACL Cannonical External User ##########
/*resource "aws_s3_bucket_acl" "terra_bucket11" {
  bucket = aws_s3_bucket.terra_bucket11.id
  access_control_policy {
    grant {
      grantee {
        id   = var.canonical_external_account
        type = "CanonicalUser"
      }
      permission = "FULL_CONTROL"
    }
    grant {
      grantee {
        id   = var.canonical_owner_account
        type = "CanonicalUser"
      }
      permission = "FULL_CONTROL"
    }

    owner {
      id = var.canonical_owner_account
    }
  }
}*/
#######################################################################
########## bucket 11 ##########
resource "aws_s3_bucket" "terra_bucket21" {
  bucket = "com.coco.focus.${var.env}.twentyone.bucket"
  tags = {name = "bucket11","terraform" = true}
}

resource "aws_s3_bucket_ownership_controls" "terra_bucket21" {
  bucket = aws_s3_bucket.terra_bucket21.id

  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_acl" "terra_bucket21" {
  bucket = aws_s3_bucket.terra_bucket21.id
  acl    = "private"
}
