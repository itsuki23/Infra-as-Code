# ------------------------------
#  IAM for App-img to S3
# ------------------------------

resource "aws_iam_user" "app_img_to_s3" {
  name = "app-img-to-s3"
}

resource "aws_iam_access_key" "app_img_to_s3" {
  user = aws_iam_user.app_img_to_s3.name
}

resource "aws_iam_user_policy" "app_img_to_s3" {
  name = "app_img_to_s3"
  user = aws_iam_user.app_img_to_s3.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": "*"
        }
    ]
}
EOF
}


