## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| aws | ~> 2.0 |
| null | ~> 2.0 |

## Providers

| Name | Version |
|------|---------|
| aws.accepter | ~> 2.0 |
| aws.requester | ~> 2.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| accepter\_allow\_remote\_vpc\_dns\_resolution | Allow accepter VPC to resolve public DNS hostnames to private IP addresses when queried from instances in the requester VPC | `bool` | `true` | no |
| accepter\_aws\_assume\_role\_arn | Accepter AWS Assume Role ARN | `string` | n/a | yes |
| accepter\_region | Accepter AWS region | `string` | n/a | yes |
| accepter\_vpc\_id | Accepter VPC ID filter | `string` | `""` | no |
| accepter\_vpc\_tags | Accepter VPC Tags filter | `map(string)` | `{}` | no |
| attributes | Additional attributes (e.g. `a` or `b`) | `list(string)` | `[]` | no |
| auto\_accept | Automatically accept the peering | `bool` | `true` | no |
| delimiter | Delimiter to be used between `namespace`, `stage`, `name`, and `attributes` | `string` | `"-"` | no |
| enabled | Set to false to prevent the module from creating or accessing any resources | `bool` | `true` | no |
| name | Name  (e.g. `app` or `cluster`) | `string` | n/a | yes |
| namespace | Namespace (e.g. `eg` or `cp`) | `string` | n/a | yes |
| requester\_allow\_remote\_vpc\_dns\_resolution | Allow requester VPC to resolve public DNS hostnames to private IP addresses when queried from instances in the accepter VPC | `bool` | `true` | no |
| requester\_aws\_assume\_role\_arn | Requester AWS Assume Role ARN | `string` | n/a | yes |
| requester\_region | Requester AWS region | `string` | n/a | yes |
| requester\_vpc\_id | Requester VPC ID filter | `string` | `""` | no |
| requester\_vpc\_tags | Requester VPC Tags filter | `map(string)` | `{}` | no |
| stage | Stage (e.g. `prod`, `dev`, `staging`) | `string` | n/a | yes |
| tags | Additional tags (e.g. `{"BusinessUnit" = "XYZ"`) | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| accepter\_accept\_status | Accepter VPC peering connection request status |
| accepter\_connection\_id | Accepter VPC peering connection ID |
| requester\_accept\_status | Requester VPC peering connection request status |
| requester\_connection\_id | Requester VPC peering connection ID |

