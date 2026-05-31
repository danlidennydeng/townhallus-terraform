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