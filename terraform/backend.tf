// S3 remote backend configuration for Terraform state
// Update the `bucket`, `key`, and `region` values as needed.
terraform {
  backend "s3" {
    bucket       = "hackathon-sell-my-stuff-terraform-state-12hadf3"
    key          = "terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
    # dynamodb_table = "terraform-state-locks"
  }
}

// Notes:
// - Ensure the S3 bucket exists and the executing AWS identity has read/write access.
// - The `dynamodb_table` is optional but recommended for state locking.
//   Create it with a primary key named `LockID` (string).
// - Do NOT commit sensitive backend override files. Use environment variables
//   or `-backend-config` to override values when necessary.
