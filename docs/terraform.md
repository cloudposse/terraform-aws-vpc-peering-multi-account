<!-- markdownlint-disable -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 2.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws.accepter"></a> [aws.accepter](#provider\_aws.accepter) | >= 2.0 |
| <a name="provider_aws.requester"></a> [aws.requester](#provider\_aws.requester) | >= 2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_accepter"></a> [accepter](#module\_accepter) | cloudposse/label/null | 0.24.1 |
| <a name="module_requester"></a> [requester](#module\_requester) | cloudposse/label/null | 0.24.1 |
| <a name="module_this"></a> [this](#module\_this) | cloudposse/label/null | 0.24.1 |

## Resources

| Name | Type |
|------|------|
| [aws_route.accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.requester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_vpc_peering_connection.requester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection) | resource |
| [aws_vpc_peering_connection_accepter.accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_accepter) | resource |
| [aws_vpc_peering_connection_options.accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_options) | resource |
| [aws_vpc_peering_connection_options.requester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_options) | resource |
| [aws_caller_identity.accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_caller_identity.requester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_region.requester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_route_table.accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_table) | data source |
| [aws_route_table.requester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_table) | data source |
| [aws_subnet_ids.accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet_ids) | data source |
| [aws_subnet_ids.requester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet_ids) | data source |
| [aws_vpc.accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [aws_vpc.requester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_accepter_allow_remote_vpc_dns_resolution"></a> [accepter\_allow\_remote\_vpc\_dns\_resolution](#input\_accepter\_allow\_remote\_vpc\_dns\_resolution) | Allow accepter VPC to resolve public DNS hostnames to private IP addresses when queried from instances in the requester VPC | `bool` | `true` | no |
| <a name="input_accepter_subnet_tags"></a> [accepter\_subnet\_tags](#input\_accepter\_subnet\_tags) | Only add peer routes to accepter VPC route tables of subnets matching these tags | `map(string)` | `{}` | no |
| <a name="input_accepter_vpc_id"></a> [accepter\_vpc\_id](#input\_accepter\_vpc\_id) | Accepter VPC ID filter | `string` | `""` | no |
| <a name="input_accepter_vpc_tags"></a> [accepter\_vpc\_tags](#input\_accepter\_vpc\_tags) | Accepter VPC Tags filter | `map(string)` | `{}` | no |
| <a name="input_add_attribute_tag"></a> [add\_attribute\_tag](#input\_add\_attribute\_tag) | If `true` will add additional attribute tag to the requester and accceptor resources | `bool` | `true` | no |
| <a name="input_additional_tag_map"></a> [additional\_tag\_map](#input\_additional\_tag\_map) | Additional tags for appending to tags\_as\_list\_of\_maps. Not added to `tags`. | `map(string)` | `{}` | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | Additional attributes (e.g. `1`) | `list(string)` | `[]` | no |
| <a name="input_auto_accept"></a> [auto\_accept](#input\_auto\_accept) | Automatically accept the peering | `bool` | `true` | no |
| <a name="input_context"></a> [context](#input\_context) | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | `any` | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_key_case": null,<br>  "label_order": [],<br>  "label_value_case": null,<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {}<br>}</pre> | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes`.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment, e.g. 'uw2', 'us-west-2', OR 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit) | Limit `id` to this many characters (minimum 6).<br>Set to `0` for unlimited length.<br>Set to `null` for default, which is `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| <a name="input_label_key_case"></a> [label\_key\_case](#input\_label\_key\_case) | The letter case of label keys (`tag` names) (i.e. `name`, `namespace`, `environment`, `stage`, `attributes`) to use in `tags`.<br>Possible values: `lower`, `title`, `upper`.<br>Default value: `title`. | `string` | `null` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The naming order of the id output and Name tag.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 5 elements, but at least one must be present. | `list(string)` | `null` | no |
| <a name="input_label_value_case"></a> [label\_value\_case](#input\_label\_value\_case) | The letter case of output label values (also used in `tags` and `id`).<br>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br>Default value: `lower`. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Solution name, e.g. 'app' or 'jenkins' | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp' | `string` | `null` | no |
| <a name="input_regex_replace_chars"></a> [regex\_replace\_chars](#input\_regex\_replace\_chars) | Regex to replace chars with empty string in `namespace`, `environment`, `stage` and `name`.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| <a name="input_requester_allow_remote_vpc_dns_resolution"></a> [requester\_allow\_remote\_vpc\_dns\_resolution](#input\_requester\_allow\_remote\_vpc\_dns\_resolution) | Allow requester VPC to resolve public DNS hostnames to private IP addresses when queried from instances in the accepter VPC | `bool` | `true` | no |
| <a name="input_requester_subnet_tags"></a> [requester\_subnet\_tags](#input\_requester\_subnet\_tags) | Only add peer routes to requester VPC route tables of subnets matching these tags | `map(string)` | `{}` | no |
| <a name="input_requester_vpc_id"></a> [requester\_vpc\_id](#input\_requester\_vpc\_id) | Requester VPC ID filter | `string` | `""` | no |
| <a name="input_requester_vpc_tags"></a> [requester\_vpc\_tags](#input\_requester\_vpc\_tags) | Requester VPC Tags filter | `map(string)` | `{}` | no |
| <a name="input_skip_metadata_api_check"></a> [skip\_metadata\_api\_check](#input\_skip\_metadata\_api\_check) | Don't use the credentials of EC2 instance profile | `bool` | `false` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `map('BusinessUnit','XYZ')` | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_accepter_accept_status"></a> [accepter\_accept\_status](#output\_accepter\_accept\_status) | Accepter VPC peering connection request status |
| <a name="output_accepter_connection_id"></a> [accepter\_connection\_id](#output\_accepter\_connection\_id) | Accepter VPC peering connection ID |
| <a name="output_requester_accept_status"></a> [requester\_accept\_status](#output\_requester\_accept\_status) | Requester VPC peering connection request status |
| <a name="output_requester_connection_id"></a> [requester\_connection\_id](#output\_requester\_connection\_id) | Requester VPC peering connection ID |
<!-- markdownlint-restore -->
