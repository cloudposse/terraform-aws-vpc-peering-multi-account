# Migration Guide: v1.x to v2.0

## Breaking Change: Provider Configuration

In v2.0, the module no longer contains hardcoded `provider "aws"` blocks. Instead, it uses `configuration_aliases` and expects providers to be passed in by the caller. This enables the module to be used with `for_each`, `count`, and `depends_on`.

## Removed Variables

The following variables have been removed. Provider configuration (region, credentials, assume role) is now handled by defining providers in your root module.

| Removed Variable | Previously Used For |
|---|---|
| `requester_aws_assume_role_arn` | IAM role to assume for the requester account |
| `requester_region` | AWS region of the requester |
| `requester_aws_profile` | AWS CLI profile for the requester |
| `requester_aws_access_key` | Access key for the requester |
| `requester_aws_secret_key` | Secret key for the requester |
| `requester_aws_token` | Session token for the requester |
| `accepter_aws_assume_role_arn` | IAM role to assume for the accepter account |
| `accepter_region` | AWS region of the accepter |
| `accepter_aws_profile` | AWS CLI profile for the accepter |
| `accepter_aws_access_key` | Access key for the accepter |
| `accepter_aws_secret_key` | Secret key for the accepter |
| `accepter_aws_token` | Session token for the accepter |
| `skip_metadata_api_check` | Skip EC2 metadata API check on providers |

## Migration Steps

### Before (v1.x)

```hcl
module "vpc_peering" {
  source  = "cloudposse/vpc-peering-multi-account/aws"
  version = "~> 1.0"

  requester_aws_assume_role_arn             = "arn:aws:iam::111111111111:role/peering-role"
  requester_region                          = "us-west-2"
  requester_vpc_id                          = "vpc-xxxxxxxx"
  requester_allow_remote_vpc_dns_resolution = true

  accepter_aws_assume_role_arn             = "arn:aws:iam::222222222222:role/peering-role"
  accepter_region                          = "us-east-1"
  accepter_vpc_id                          = "vpc-yyyyyyyy"
  accepter_allow_remote_vpc_dns_resolution = true
}
```

### After (v2.0)

```hcl
# 1. Define providers in your root module
provider "aws" {
  alias  = "requester"
  region = "us-west-2"

  assume_role {
    role_arn = "arn:aws:iam::111111111111:role/peering-role"
  }
}

provider "aws" {
  alias  = "accepter"
  region = "us-east-1"

  assume_role {
    role_arn = "arn:aws:iam::222222222222:role/peering-role"
  }
}

# 2. Pass providers explicitly and remove deleted variable arguments
module "vpc_peering" {
  source  = "cloudposse/vpc-peering-multi-account/aws"
  version = "~> 2.0"

  providers = {
    aws.requester = aws.requester
    aws.accepter  = aws.accepter
  }

  requester_vpc_id                          = "vpc-xxxxxxxx"
  requester_allow_remote_vpc_dns_resolution = true

  accepter_vpc_id                          = "vpc-yyyyyyyy"
  accepter_allow_remote_vpc_dns_resolution = true
}
```

### Key Differences

1. **Define providers externally** -- Create `provider "aws"` blocks with `alias = "requester"` and `alias = "accepter"` in your root module, including region, assume_role, and any credential configuration.
2. **Pass providers to the module** -- Add a `providers` block to the module call mapping `aws.requester` and `aws.accepter`.
3. **Remove deleted arguments** -- Delete `requester_region`, `requester_aws_assume_role_arn`, `accepter_region`, `accepter_aws_assume_role_arn`, and all other removed variables from the module call.

## Using `for_each` (New Capability)

With v2.0, you can now loop over the module:

```hcl
locals {
  peering_configs = {
    "dev-to-shared" = {
      requester_vpc_id = "vpc-aaa"
      accepter_vpc_id  = "vpc-bbb"
    }
    "dev-to-prod" = {
      requester_vpc_id = "vpc-aaa"
      accepter_vpc_id  = "vpc-ccc"
    }
  }
}

module "vpc_peering" {
  source   = "cloudposse/vpc-peering-multi-account/aws"
  for_each = local.peering_configs

  providers = {
    aws.requester = aws.requester
    aws.accepter  = aws.accepter
  }

  requester_vpc_id = each.value.requester_vpc_id
  accepter_vpc_id  = each.value.accepter_vpc_id
}
```

## State Migration

Since only provider configuration was removed (no resources changed), upgrading should not require state manipulation. However, we recommend running `terraform plan` after upgrading to confirm no unexpected changes before applying.
