locals {
  region       = "us-east-1"
  my_domain    = "riosr.com"
  s3_origin_id = "sellmystuffS3Origin"
}

# Configure the AWS Provider
provider "aws" {
  region = local.region
}
