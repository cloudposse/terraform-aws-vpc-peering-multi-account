## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| accepter_allow_remote_vpc_dns_resolution | Allow accepter VPC to resolve public DNS hostnames to private IP addresses when queried from instances in the requester VPC | string | `true` | no |
| accepter_aws_assume_role_arn | Accepter AWS Assume Role ARN | string | - | yes |
| accepter_region | Accepter AWS region | string | - | yes |
| accepter_vpc_id | Acceptor VPC ID | string | - | yes |
| attributes | Additional attributes (e.g. `a` or `b`) | list | `<list>` | no |
| auto_accept | Automatically accept the peering | string | `true` | no |
| delimiter | Delimiter to be used between `namespace`, `stage`, `name`, and `attributes` | string | `-` | no |
| enabled | Set to false to prevent the module from creating or accessing any resources | string | `true` | no |
| name | Name  (e.g. `app` or `cluster`) | string | - | yes |
| namespace | Namespace (e.g. `cp` or `cloudposse`) | string | - | yes |
| requester_allow_remote_vpc_dns_resolution | Allow requester VPC to resolve public DNS hostnames to private IP addresses when queried from instances in the accepter VPC | string | `true` | no |
| requester_aws_assume_role_arn | Requester AWS Assume Role ARN | string | - | yes |
| requester_region | Requester AWS region | string | - | yes |
| requester_vpc_id | Requestor VPC ID | string | - | yes |
| stage | Stage (e.g. `prod`, `dev`, `staging`) | string | - | yes |
| tags | Additional tags (e.g. `{"BusinessUnit" = "XYZ"`) | map | `<map>` | no |

## Outputs

| Name | Description |
|------|-------------|
| accepter_accept_status | Accepter VPC peering connection request status |
| accepter_connection_id | Accepter VPC peering connection ID |
| requester_accept_status | Requester VPC peering connection request status |
| requester_connection_id | Requester VPC peering connection ID |

