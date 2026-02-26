terraform {
  required_version = ">= 1.3"

  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = ">= 2.0"
      configuration_aliases = [aws.requester, aws.accepter]
    }
  }
}
