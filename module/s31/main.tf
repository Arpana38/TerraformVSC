######################################################################################################
####################  TERRAFORM SCRIPT TO CREATE S3 BUCKETS FOR THE SIA APPLICATION ##################
########## bucket 11 output ##########
output "bucket_arn" {
    value = aws_s3_bucket.terra_bucket11.arn
}
output "terra_bucket11_arn" {
    value = aws_s3_bucket.terra_bucket11.arn
}
########## bucket 11 ##########
resource "aws_s3_bucket" "terra_bucket11" {
  bucket = "com.coco.focus.${var.env}.eleven.bucket"
  tags = {name = "bucket11","terraform" = true}
}
########## data source lambda #####
#data "aws_lambda_function" "bucket11-lambda" {
#  function_name = "bucket11-lambda"
#}
########## bucket 11 policy ##########
resource "aws_s3_bucket_policy" "terra_bucket11" {
  count  = fileexists("module/s3/com.coco.focus.${var.env}.eleven.bucket.json") ? 1 : 0
  bucket = aws_s3_bucket.terra_bucket11.id
  policy = file("module/s3/com.coco.focus.${var.env}.eleven.bucket.json")
  #env=stage(has policy)  #env=prod(no policy) how to use 1:0? create if exist,do not create if not exit.
}
########## bucket 11 Versioning ##########
resource "aws_s3_bucket_versioning" "terra_bucket11" {
  bucket = aws_s3_bucket.terra_bucket11.id
  versioning_configuration {
    status = "Suspended"
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
########## bucket 11 folder creation ##############
### import manually created folder only not object ####
# Findings = we cannot import s3 folder but we can create the resource for s3 folder and apply. When apply after creating s3 folder resource,s3 folder will be captured by terraform but objects in the folder will not be impacted. 
### Below is working ###
/*
resource "aws_s3_object" "terra_bucket11" {
  bucket = aws_s3_bucket.terra_bucket11.id
  acl = "private"
  key = "external/index1.txt"    #folder and name of the file in s3
  source = "./module/s3/index.txt"  #path to source/file which will be read.Data inside it will be uploaded/inserted in key path.
}
*/
/*
resource "aws_s3_object" "bucket11_folders" {
    for_each = toset(var.bucket11_folder)
    bucket = aws_s3_bucket.terra_bucket11.id
    acl = "private"
    key = each.key
}*/
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