<!-- markdownlint-disable -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.0 |
| aws | >= 2.0 |
| null | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| aws.accepter | >= 2.0 |
| aws.requester | >= 2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| accepter | cloudposse/label/null | 0.24.1 |
| requester | cloudposse/label/null | 0.24.1 |
| this | cloudposse/label/null | 0.24.1 |

## Resources

| Name |
|------|
| [aws_caller_identity](https://registry.terraform.io/providers/hashicorp/aws/2.0/docs/data-sources/caller_identity) |
| [aws_region](https://registry.terraform.io/providers/hashicorp/aws/2.0/docs/data-sources/region) |
| [aws_route](https://registry.terraform.io/providers/hashicorp/aws/2.0/docs/resources/route) |
| [aws_route_table](https://registry.terraform.io/providers/hashicorp/aws/2.0/docs/data-sources/route_table) |
| [aws_route_tables](https://registry.terraform.io/providers/hashicorp/aws/2.0/docs/data-sources/route_tables) |
| [aws_subnet_ids](https://registry.terraform.io/providers/hashicorp/aws/2.0/docs/data-sources/subnet_ids) |
| [aws_vpc](https://registry.terraform.io/providers/hashicorp/aws/2.0/docs/data-sources/vpc) |
| [aws_vpc_peering_connection](https://registry.terraform.io/providers/hashicorp/aws/2.0/docs/resources/vpc_peering_connection) |
| [aws_vpc_peering_connection_accepter](https://registry.terraform.io/providers/hashicorp/aws/2.0/docs/resources/vpc_peering_connection_accepter) |
| [aws_vpc_peering_connection_options](https://registry.terraform.io/providers/hashicorp/aws/2.0/docs/resources/vpc_peering_connection_options) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| accepter\_allow\_remote\_vpc\_dns\_resolution | Allow accepter VPC to resolve public DNS hostnames to private IP addresses when queried from instances in the requester VPC | `bool` | `true` | no |
| accepter\_aws\_access\_key | Access key id to use in accepter account | `string` | `""` | no |
| accepter\_aws\_assume\_role\_arn | Accepter AWS Assume Role ARN | `string` | n/a | yes |
| accepter\_aws\_profile | Profile used to assume accepter\_aws\_assume\_role\_arn | `string` | `""` | no |
| accepter\_aws\_secret\_key | Secret access key to use in accepter account | `string` | `""` | no |
| accepter\_aws\_token | Session token for validating temporary credentials | `string` | `""` | no |
| accepter\_region | Accepter AWS region | `string` | n/a | yes |
| accepter\_subnet\_tags | Only add peer routes to accepter VPC route tables of subnets matching these tags | `map(string)` | `{}` | no |
| accepter\_vpc\_id | Accepter VPC ID filter | `string` | `""` | no |
| accepter\_vpc\_tags | Accepter VPC Tags filter | `map(string)` | `{}` | no |
| additional\_tag\_map | Additional tags for appending to tags\_as\_list\_of\_maps. Not added to `tags`. | `map(string)` | `{}` | no |
| attributes | Additional attributes (e.g. `1`) | `list(string)` | `[]` | no |
| auto\_accept | Automatically accept the peering | `bool` | `true` | no |
| context | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | `any` | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_key_case": null,<br>  "label_order": [],<br>  "label_value_case": null,<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {}<br>}</pre> | no |
| delimiter | Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes`.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| enabled | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| environment | Environment, e.g. 'uw2', 'us-west-2', OR 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| id\_length\_limit | Limit `id` to this many characters (minimum 6).<br>Set to `0` for unlimited length.<br>Set to `null` for default, which is `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| label\_key\_case | The letter case of label keys (`tag` names) (i.e. `name`, `namespace`, `environment`, `stage`, `attributes`) to use in `tags`.<br>Possible values: `lower`, `title`, `upper`.<br>Default value: `title`. | `string` | `null` | no |
| label\_order | The naming order of the id output and Name tag.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 5 elements, but at least one must be present. | `list(string)` | `null` | no |
| label\_value\_case | The letter case of output label values (also used in `tags` and `id`).<br>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br>Default value: `lower`. | `string` | `null` | no |
| name | Solution name, e.g. 'app' or 'jenkins' | `string` | `null` | no |
| namespace | Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp' | `string` | `null` | no |
| regex\_replace\_chars | Regex to replace chars with empty string in `namespace`, `environment`, `stage` and `name`.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| requester\_allow\_remote\_vpc\_dns\_resolution | Allow requester VPC to resolve public DNS hostnames to private IP addresses when queried from instances in the accepter VPC | `bool` | `true` | no |
| requester\_aws\_access\_key | Access key id to use in requester account | `string` | `""` | no |
| requester\_aws\_assume\_role\_arn | Requester AWS Assume Role ARN | `string` | n/a | yes |
| requester\_aws\_profile | Profile used to assume requester\_aws\_assume\_role\_arn | `string` | `""` | no |
| requester\_aws\_secret\_key | Secret access key to use in requester account | `string` | `""` | no |
| requester\_aws\_token | Session token for validating temporary credentials | `string` | `""` | no |
| requester\_region | Requester AWS region | `string` | n/a | yes |
| requester\_subnet\_tags | Only add peer routes to requester VPC route tables of subnets matching these tags | `map(string)` | `{}` | no |
| requester\_vpc\_id | Requester VPC ID filter | `string` | `""` | no |
| requester\_vpc\_tags | Requester VPC Tags filter | `map(string)` | `{}` | no |
| skip\_metadata\_api\_check | Don't use the credentials of EC2 instance profile | `bool` | `false` | no |
| stage | Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| tags | Additional tags (e.g. `map('BusinessUnit','XYZ')` | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| accepter\_accept\_status | Accepter VPC peering connection request status |
| accepter\_connection\_id | Accepter VPC peering connection ID |
| requester\_accept\_status | Requester VPC peering connection request status |
| requester\_connection\_id | Requester VPC peering connection ID |
<!-- markdownlint-restore -->
