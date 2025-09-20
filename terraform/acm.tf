data "aws_acm_certificate" "my_domain" {
  region   = local.region
  domain   = "*.${local.my_domain}"
  statuses = ["ISSUED"]
}