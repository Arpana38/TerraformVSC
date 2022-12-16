#############################################################################################
########################################## Bucket 2 #########################################
#######################################  Main Bucket 2 ######################################
#import a s3 bucket using terraform. The manual created bucket should be imported.
#manual created bucket. Later, it was imported.
resource "aws_s3_bucket" "imported_bucket2" {
  bucket = "buctesting1"
  tags = {
    name = "tag-bucket2"
  }
}
/*
##############################################################################################
resource "aws_kms_key" "imported_bucket2_mykey" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}*/
############################################ Encrption #######################################
resource "aws_s3_bucket_server_side_encryption_configuration" "imported_bucket2_encryption" {
  bucket = aws_s3_bucket.imported_bucket2.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
#      kms_master_key_id = "arn:aws:kms:us-east-1:409269111861:key/20b3be2f-67b8-46f3-a9d1-8a08fec73d0c"
#      sse_algorithm     = "aws:kms"
    }
  }
}
#      kms_master_key_id = "arn:aws:kms:us-east-1:409269111861:key/20b3be2f-67b8-46f3-a9d1-8a08fec73d0c"
#      sse_algorithm     = "aws:kms"
############################## Bucket 2 Block Public Access ##############################
resource "aws_s3_bucket_public_access_block" "imported_bucket2_BPL" {
  bucket = aws_s3_bucket.imported_bucket2.id

  block_public_acls       = true          #1
  ignore_public_acls      = true       #2
  block_public_policy     = true        #3
  restrict_public_buckets = false          #4   
  #if only one of them is false, block all public access status is OFF. 
  #if all of them is true, block all public access status if ON. 
}
################################### ownership #############################################
/*resource "aws_s3_bucket_ownership_controls" "imported_bucket2_ownership" {
  bucket = aws_s3_bucket.imported_bucket2.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}*/
####################################### Bucket 2 Policy ###################################
resource "aws_s3_bucket_policy" "imported_bucket2_allow_access_principal" {
  bucket = aws_s3_bucket.imported_bucket2.id
  policy = data.aws_iam_policy_document.imported_bucket2_allow_access_principal.json
}

data "aws_iam_policy_document" "imported_bucket2_allow_access_principal" {
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
}
######################################## ACL #############################################
resource "aws_s3_bucket_acl" "imported_bucket2_acl" {
  bucket = aws_s3_bucket.imported_bucket2.id
  acl    = "private"
}
################################### Bucket 2 Versioning #####################################
resource "aws_s3_bucket_versioning" "imported_bucket2_versioning" {
  bucket = aws_s3_bucket.imported_bucket2.id
  versioning_configuration {
    status = "Enabled"
  }
}
############################## Bucket 2 lifecycle configuration ##############################
resource "aws_s3_bucket_lifecycle_configuration" "lifecycle_bucket2" {
  bucket = aws_s3_bucket.imported_bucket2.id
  rule {
    id = "bucket2lifecycle"
    status = "Enabled"
    expiration {
      days = 15
    }
  }
}
#################################### Bucket 2 object creation ##################################
#VSC create object
resource "aws_s3_object" "VSC_object1" {
  bucket = aws_s3_bucket.imported_bucket2.id
  key    = "VSCcreatednote1"    #key is name of the object in bucket
  source = "note1"                    #name of data file location. data inside file will be uploaded inside object(key).
}
#VSC created object
resource "aws_s3_object" "VSC_object2" {
  bucket = aws_s3_bucket.imported_bucket2.id
  key    = "VSCcreatednote2"    
  source = "note2"  
}
#VSC created object then uploaded to bucket
resource "aws_s3_object" "VSC_object3" {
  bucket = aws_s3_bucket.imported_bucket2.id
  key    = "VSCcreatednote3"    
  source = "note3"  
}
/*
#import file uploaded to bucket manually
#issue: how to import object manually upload to terraform?
resource "aws_s3_object" "import_manualcode1_object4" {
  bucket = aws_s3_bucket.imported_bucket2.id
  key    = "manualcode1.txt"    
  source = "null"  
}
*/
