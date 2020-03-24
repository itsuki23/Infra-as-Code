# ------------------------------
#  Var
# ------------------------------

# prefix = climb
# region = "ap-northeast-1"



# ------------------------------
#  S3 for Web-img
# ------------------------------

# # s3 for web-img
resource "aws_s3_bucket" "web_img" {
  bucket = "climb-web-img"
  region = "ap-northeast-1"
}

# # policy for alb-log-s3
# resource "aws_s3_bucket_policy" "web_img" {
#   bucket = aws_s3_bucket.web_img.id
#   policy = data.aws_iam_policy_document.web_img.json
# }
# data "aws_iam_policy_document" "web_img" {
#   statement {
#     effect = "Allow"
#     actions = ["s3:*"]
#     resources = ["arn:aws:s3:::aws_s3_bucket.web_img.id/*"]

#     principals {
#       type = "AWS"
#       identifiers = ["582318560864"]
#     }
#   }
# }
