######################################################################################################
####################  TERRAFORM SCRIPT TO CREATE S3 BUCKETS FOR THE SIA APPLICATION ##################
######################################################################################################

########## bucket 12 output ##########
output "bucket_arn" {
    value = aws_s3_bucket.terra_bucket12.arn
}
########## bucket 12 ##########
resource "aws_s3_bucket" "terra_bucket12" {
  bucket = "buctesting12"
  tags = {name = "bucket12","terraform" = true}
}
########## bucket 12 Versioning ##########
resource "aws_s3_bucket_versioning" "terra_bucket12" {
  bucket = aws_s3_bucket.terra_bucket12.id
  versioning_configuration {
    status = "Disabled"
  }
}
########## bucket 12 encryption ##########
/*
resource "aws_s3_bucket_server_side_encryption_configuration" "terra_bucket12" {
  bucket = aws_s3_bucket.terra_bucket12.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}*/
########## bucket 12 public access block ########## 
resource "aws_s3_bucket_public_access_block" "terra_bucket12" {
  bucket = aws_s3_bucket.terra_bucket12.id

  block_public_acls       = true          #1
  ignore_public_acls      = true          #2
  block_public_policy     = true         #3     #if only one of them is false, block all public access status is OFF. 
  restrict_public_buckets = true         #4     #if all of them is true, block all public access status if ON. 
}
########## bucket 12 policy ##########
/*resource "aws_s3_bucket_policy" "terra_bucket12" {
  bucket = aws_s3_bucket.terra_bucket12.id
  policy = data.aws_iam_policy_document.terra_bucket1.json
}

data "aws_iam_policy_document" "terra_bucket12" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::409269111861:root"]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.imported_bucket2.arn,
      "${aws_s3_bucket.imported_bucket2.arn}/*",
    ]
  }
*/
########## bucket 12 object ownership ##########
resource "aws_s3_bucket_ownership_controls" "terra_bucket12" {
  bucket = aws_s3_bucket.terra_bucket12.id
  rule {
    object_ownership = "BucketOwnerEnforced"      #BucketOwnerPreferred
  }
}
########## bucket 12 ACL ##########
#what is meant by ACL private?where does the change happen in console?
#note: need to have acl enabled to use this by (resource:bucket_ownership_control) OR, enable ACL manually
/*resource "aws_s3_bucket_acl" "terra_bucket12" {       
  bucket = aws_s3_bucket.terra_bucket12.id
  acl    = "FULL_CONTROL"   #private
#  acl    = "authenticated-read"
}
/*
########## bucket 12 lifecycle ##########
resource "aws_s3_bucket_lifecycle_configuration" "terra_bucket12" {
  bucket = aws_s3_bucket.terra_bucket12.id
  rule {
    id = "bucket12lifecycle"
    status = "Enabled"
    expiration {
      days = 15
    }
  }
}
*/ 