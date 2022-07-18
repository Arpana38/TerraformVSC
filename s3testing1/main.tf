#############################################################################################
########################################## Bucket 1 #########################################
#Create a s3 bucket using terraform
resource "aws_s3_bucket" "s3_bucket_1" {
  bucket = "t-s3bucket-blank1"
  
  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
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
############################## Bucket 2 Block Public Access ##############################
resource "aws_s3_bucket_public_access_block" "imported_bucket2_BPL" {
  bucket = aws_s3_bucket.imported_bucket2.id

  block_public_acls       = true          #1
  ignore_public_acls      = true         #2
  block_public_policy     = true          #3
  restrict_public_buckets = true         #4   
  #if only one of them is false, block all public access status is OFF. 
  #if all of them is true, block all public access status if ON. 
}/*
###################################  ##### ACL #############################################
resource "aws_s3_bucket_acl" "imported_bucket2_acl" {
  bucket = aws_s3_bucket.imported_bucket2.id
  acl    = "private"
}*/
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
    id = "rule-1"
    status = "Enabled"
    expiration {
      days = 30
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
#############################################################################################
########################################## Bucket 3 #########################################
#import manually created bucket to terraform configuration and add lifecycle policy
resource "aws_s3_bucket" "imported_bucket3" {
  bucket = "buctesting3manualcreated"
}
############################## Bucket 3 lifecycle configuration ##############################
resource "aws_s3_bucket_lifecycle_configuration" "lifecycle_bucket3" {
  bucket = aws_s3_bucket.imported_bucket3.id

  rule {
    id = "rule-1"
    status = "Enabled"
    expiration {
      days = 30
    }
  }
}
#############################################################################################
###################################### Bucket 4 Manual ######################################
#import manually created bucket to terraform configuration which aleady have tag and lifecycle configured
#for testing change the tag name
#for testing change the lifecycle number of days
resource "aws_s3_bucket" "imported_bucket4" {
  bucket = "buctesting4manualcreated"
  tags = {
    name = "tagbuctesting4manualcreated"
  }
}
################################### Bucket 2 Versioning #####################################
resource "aws_s3_bucket_versioning" "imported_bucket4_versioning" {
  bucket = aws_s3_bucket.imported_bucket4.id
  versioning_configuration {
    status = "Enabled"
  }
}
############################## Bucket 3 lifecycle configuration ##############################
###
#ERROR
####
resource "aws_s3_bucket_lifecycle_configuration" "lifecycle_bucket4" {
  depends_on = [aws_s3_bucket_versioning.imported_bucket4_versioning]
  bucket = aws_s3_bucket.imported_bucket4.bucket

  rule {
    id = "lifecyclebuctesting4"
    status = "Enabled"
    expiration {
      days = 30
    }
  }
}
#send this
