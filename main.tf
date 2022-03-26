provider "aws" {
  region = "us-east-1"
}

locals {

  common_tags = {
    data-classification = "confidential"
    off-hours-shutdown  = "disabled"
    product             = "dte"
    environment         = "sandbox"
  }
}