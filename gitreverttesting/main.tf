#add and commit and then revert back
resource "aws_s3_bucket" "imported_bucket2" {
  bucket = "buctesting1"
  tags = {
    name = "tag-bucket2"
  }
}
