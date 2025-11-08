# Fișier Terraform pentru configurarea backendului S3.
terraform {
  required_version = ">= 1.5.0"

  backend "local" {
    path = "terraform.tfstate"
  }
}

