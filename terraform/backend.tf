# Fișier Terraform pentru configurarea backendului S3.
terraform {
  backend "s3" {
    bucket = "terraform-state"
    key    = "monitoring/terraform.tfstate"
    region = "us-east-1"
    endpoint = "http://localhost:4566"

    access_key                  = "test"
    secret_key                  = "test"
    skip_credentials_validation = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    force_path_style            = true
  }
}

