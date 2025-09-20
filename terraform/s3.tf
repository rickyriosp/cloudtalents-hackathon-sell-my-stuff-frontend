# See https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-restricting-access-to-s3.html
data "aws_iam_policy_document" "origin_bucket_policy" {
  statement {
    sid    = "AllowCloudFrontServicePrincipalReadWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]

    resources = [
      "${aws_s3_bucket.s3_bucket_frontend.arn}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.s3_distribution.arn]
    }
  }
}

resource "aws_s3_bucket" "s3_bucket_frontend" {
  bucket = "hackathon-sell-my-stuff-frontend-asd873a"
  
  # Allow Terraform to delete non-empty buckets (will remove all objects)
  force_destroy = true

  tags = {
    Name        = "hackathon-sell-my-stuff"
    Environment = "dev"
  }
}

resource "aws_s3_bucket_policy" "s3_bucket_frontend_policy" {
  bucket = aws_s3_bucket.s3_bucket_frontend.id
  policy = data.aws_iam_policy_document.origin_bucket_policy.json
}

resource "aws_s3_bucket_public_access_block" "s3_bucket_frontend_public_access_block" {
  bucket = aws_s3_bucket.s3_bucket_frontend.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3 Bucket Website Configuration
# resource "aws_s3_bucket_website_configuration" "s3_bucket_frontend_website" {
#   bucket = aws_s3_bucket.s3_bucket_frontend.id

#   index_document {
#     suffix = "index.html"
#   }

#   error_document {
#     key = "error.html"
#   }
# }