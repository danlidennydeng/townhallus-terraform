# resource "aws_s3_bucket" "tf_s3_bucket" {
#   bucket = "testing-townhallus"

#   tags = {
#     Name        = "testing first"
#   }
# }

# resource "aws_s3_object" "tf_s3_object" {
#   bucket = aws_s3_bucket.tf_s3_bucket.bucket
# 	for_each = fileset("../hoohootowns/client/public", "**")
#   key = "public/${each.key}"
#   source = "../hoohootowns/client/public/${each.key}"

# }

//above tested successfully so terraform setup is successful.

//step 3
resource "aws_s3_bucket" "frontend_www" {
  bucket = "www.townhallus.com"

  tags = {
    Project = "townhallus"
    Name    = "www.townhallus.com"
  }
}

resource "aws_s3_bucket_public_access_block" "frontend_www" {
  bucket = aws_s3_bucket.frontend_www.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}