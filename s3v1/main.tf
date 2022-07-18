########################################## Bucket 5 #########################################
#terraform created bucket
resource "aws_s3_bucket" "terra_bucket5" {
  bucket = "terrabucket5"
  tags = {
    name = "terrabucket5"
  }
}
############################## Bucket 5 Block Public Access ##############################
resource "aws_s3_bucket_public_access_block" "terra_bucket5_BPL" {
  bucket = aws_s3_bucket.terra_bucket5.id

  block_public_acls       = false          #1
  ignore_public_acls      = false         #2
  block_public_policy     = false         #3
  restrict_public_buckets = false         #4   
  #if only one of them is false, block all public access status is OFF. 
  #if all of them is true, block all public access status if ON. 
}
#################################### Bucket 5 ACL #############################################
resource "aws_s3_bucket_acl" "terra_bucket5_acl" {
  bucket = aws_s3_bucket.terra_bucket5.id
  acl    = "private"
}
################################### Bucket 2 Versioning #####################################
resource "aws_s3_bucket_versioning" "terra_bucket5_versioning" {
  bucket = aws_s3_bucket.terra_bucket5.id
  versioning_configuration {
    status = "Enabled"
  }
}
############################## Bucket 2 lifecycle configuration ##############################
resource "aws_s3_bucket_lifecycle_configuration" "terra_bucket5_lifecycle" {
  bucket = aws_s3_bucket.terra_bucket5.id
  rule {
    id = "rule-1"
    status = "Enabled"
    expiration {
      days = 30
    }
  }
}
/*
#################################### Bucket 5 object creation ##################################
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
#import file uploaded to bucket manually
#issue: how to import object manually upload to terraform?
resource "aws_s3_object" "import_manualcode1_object4" {
  bucket = aws_s3_bucket.imported_bucket2.id
  key    = "manualcode1.txt"    
  source = "null"  
}
*/