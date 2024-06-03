provider "exoscale" {
  key    = var.key
  secret = var.secret
}

# provider "aws" {
#
#   endpoints {
#     s3 = "https://sos-${var.zone}.exo.io"
#   }
#
#   region     = var.zone
#
#   # access_key = var.s3_access_key
#   # secret_key = var.s3_secret_key
#
#   # Disable AWS-specific features
#   skip_credentials_validation = true
#   skip_region_validation      = true
#   skip_requesting_account_id  = true
#   skip_s3_checksum            = true
# }
