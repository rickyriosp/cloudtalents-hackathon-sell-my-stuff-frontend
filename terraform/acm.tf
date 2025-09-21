# data "aws_acm_certificate" "my_domain" {
#   region   = local.region
#   domain   = "*.${local.my_domain}"
#   statuses = ["ISSUED"]
# }

resource "aws_acm_certificate" "my_domain" {
  domain_name       = "sellmystuff.riosr.com"
  validation_method = "DNS"
  validation_option {
    domain_name       = "sellmystuff.riosr.com"
    validation_domain = "riosr.com"
  }

  lifecycle {
    create_before_destroy = true
  }
}