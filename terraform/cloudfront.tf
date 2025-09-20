resource "aws_cloudfront_origin_access_control" "s3_bucket_frontend_oac" {
  name                              = "s3_bucket_frontend_oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.frontend_hosting.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_bucket_frontend_oac.id
    origin_id                = local.s3_origin_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CF distribution for hackathon-sell-my-stuff"
  default_root_object = "index.html"

  aliases = ["sellmystuff.${local.my_domain}"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none" //"whitelist"
      locations        = []     //["US", "CA", "GB", "DE"]
    }
  }

  tags = {
    Application = "hackathon-sell-my-stuff"
    Environment = "dev"
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.my_domain.arn
    ssl_support_method  = "sni-only"
    # cloudfront_default_certificate = true
  }
}