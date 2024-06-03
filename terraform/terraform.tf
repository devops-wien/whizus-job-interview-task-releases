terraform {
  required_version = ">= 1.8.4"

  required_providers {
    exoscale = {
      source  = "exoscale/exoscale"
      version = "0.59.0"
    }
  }

  backend "s3" {
    bucket    = "devops-at-vie-1-job-interviews"
    key       = "terraform.tfstate"
    region    = "at-vie-1"
    endpoint  = "https://sos-at-vie-1.exo.io"

    # access_key = var.s3_access_key
    # secret_key = var.s3_secret_key
    #
    # export AWS_ACCESS_KEY_ID=""
    # export AWS_SECRET_ACCESS_KEY=""

    skip_credentials_validation = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}
