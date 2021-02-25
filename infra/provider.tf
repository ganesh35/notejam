# provider.tf

# Specify the provider and access details
provider "aws" {
  region                    = var.aws_region
  shared_credentials_file   = "%USERPROFILE%/.aws/credentials"
  profile                   = "default"
}