# terraform-aws-vpc-peering-multi-account

 [![Latest Release](https://img.shields.io/github/release/cloudposse/terraform-aws-vpc-peering-multi-account.svg)](https://github.com/cloudposse/terraform-aws-vpc-peering-multi-account/releases/latest) [![Slack Community](https://slack.cloudposse.com/badge.svg)](https://slack.cloudposse.com)

[![README Header][readme_header_img]][readme_header_link]

[![Cloud Posse][logo]](https://cpco.io/homepage)

<!--




  ** DO NOT EDIT THIS FILE
  **
  ** This file was automatically generated by the `build-harness`.
  ** 1) Make all changes to `README.yaml`
  ** 2) Run `make init` (you only need to do this once)
  ** 3) Run`make readme` to rebuild this file.
  **
  ** (We maintain HUNDREDS of open source projects. This is how we maintain our sanity.)
  **





-->

Terraform module to create a peering connection between any two VPCs existing in different AWS accounts.

This module supports performing this action from a 3rd account (e.g. a "root" account) by specifying the roles to assume for each member account.

**IMPORTANT:** AWS allows a multi-account VPC Peering Connection to be deleted from either the requester's or accepter's side. However, Terraform only allows the VPC Peering Connection to be deleted from the requester's side by removing the corresponding `aws_vpc_peering_connection` resource from your configuration. [Read more about this](https://www.terraform.io/docs/providers/aws/r/vpc_peering_accepter.html) on Terraform's documentation portal.


---

This project is part of our comprehensive ["SweetOps"](https://cpco.io/sweetops) approach towards DevOps.
[<img align="right" title="Share via Email" src="https://docs.cloudposse.com/images/ionicons/ios-email-outline-2.0.1-16x16-999999.svg"/>][share_email]
[<img align="right" title="Share on Google+" src="https://docs.cloudposse.com/images/ionicons/social-googleplus-outline-2.0.1-16x16-999999.svg" />][share_googleplus]
[<img align="right" title="Share on Facebook" src="https://docs.cloudposse.com/images/ionicons/social-facebook-outline-2.0.1-16x16-999999.svg" />][share_facebook]
[<img align="right" title="Share on Reddit" src="https://docs.cloudposse.com/images/ionicons/social-reddit-outline-2.0.1-16x16-999999.svg" />][share_reddit]
[<img align="right" title="Share on LinkedIn" src="https://docs.cloudposse.com/images/ionicons/social-linkedin-outline-2.0.1-16x16-999999.svg" />][share_linkedin]
[<img align="right" title="Share on Twitter" src="https://docs.cloudposse.com/images/ionicons/social-twitter-outline-2.0.1-16x16-999999.svg" />][share_twitter]


[![Terraform Open Source Modules](https://docs.cloudposse.com/images/terraform-open-source-modules.svg)][terraform_modules]



It's 100% Open Source and licensed under the [APACHE2](LICENSE).







We literally have [*hundreds of terraform modules*][terraform_modules] that are Open Source and well-maintained. Check them out!





## Screenshots


![vpc-peering](images/vpc-peering.png)
*VPC Peering Connection in the AWS Web Console*



## Usage


**IMPORTANT:** The `master` branch is used in `source` just as an example. In your code, do not pin to `master` because there may be breaking changes between releases.
Instead pin to the release tag (e.g. `?ref=tags/x.y.z`) of one of our [latest releases](https://github.com/cloudposse/terraform-aws-vpc-peering-multi-account/releases).



**IMPORTANT:** Do not pin to `master` because there may be breaking changes between releases. Instead pin to the release tag (e.g. `?ref=tags/x.y.z`) of one of our [latest releases](https://github.com/cloudposse/terraform-aws-vpc-peering-multi-account/releases).

For a complete example, see [examples/complete](examples/complete)

```hcl
module "vpc_peering_cross_account" {
  source           = "git::https://github.com/cloudposse/terraform-aws-vpc-peering-multi-account.git?ref=master"
  namespace        = "eg"
  stage            = "dev"
  name             = "cluster"

  requester_aws_assume_role_arn             = "arn:aws:iam::XXXXXXXX:role/cross-account-vpc-peering-test"
  requester_region                          = "us-west-2"
  requester_vpc_id                          = "vpc-xxxxxxxx"
  requester_allow_remote_vpc_dns_resolution = true

  accepter_aws_assume_role_arn             = "arn:aws:iam::YYYYYYYY:role/cross-account-vpc-peering-test"
  accepter_region                          = "us-east-1"
  accepter_vpc_id                          = "vpc-yyyyyyyy"
  accepter_allow_remote_vpc_dns_resolution = true
}
```

The `arn:aws:iam::XXXXXXXX:role/cross-account-vpc-peering-test` requester IAM Role should have the following Trust Policy:

<details><summary>Show Trust Policy</summary>

```js
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::XXXXXXXX:root"
      },
      "Action": "sts:AssumeRole",
      "Condition": {}
    }
  ]
}
```

</details>
<br/>

and the following IAM Policy attached to it:

__NOTE:__ the policy specifies the permissions to create (with `terraform plan/apply`) and delete (with `terraform destroy`) all the required resources in the requester AWS account

<details><summary>Show IAM Policy</summary>

```js
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateRoute",
        "ec2:DeleteRoute"
      ],
      "Resource": "arn:aws:ec2:*:XXXXXXXX:route-table/*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeVpcPeeringConnections",
        "ec2:DescribeVpcs",
        "ec2:ModifyVpcPeeringConnectionOptions",
        "ec2:DescribeSubnets",
        "ec2:DescribeVpcAttribute",
        "ec2:DescribeRouteTables"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:AcceptVpcPeeringConnection",
        "ec2:DeleteVpcPeeringConnection",
        "ec2:CreateVpcPeeringConnection",
        "ec2:RejectVpcPeeringConnection"
      ],
      "Resource": [
        "arn:aws:ec2:*:XXXXXXXX:vpc-peering-connection/*",
        "arn:aws:ec2:*:XXXXXXXX:vpc/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DeleteTags",
        "ec2:CreateTags"
      ],
      "Resource": "arn:aws:ec2:*:XXXXXXXX:vpc-peering-connection/*"
    }
  ]
}
```

</details>

where `XXXXXXXX` is the requester AWS account ID.

<br/>

The `arn:aws:iam::YYYYYYYY:role/cross-account-vpc-peering-test` accepter IAM Role should have the following Trust Policy:

<details><summary>Show Trust Policy</summary>

```js
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::XXXXXXXX:root"
      },
      "Action": "sts:AssumeRole",
      "Condition": {}
    }
  ]
}
```

</details>

__NOTE__: The accepter Trust Policy is the same as the requester Trust Policy since it defines who can assume the IAM Role.
In the requester case, the requester account ID itself is the trusted entity.
For the accepter, the Trust Policy specifies that the requester account ID `XXXXXXXX` can assume the role in the accepter AWS account `YYYYYYYY`.

and the following IAM Policy attached to it:

__NOTE:__ the policy specifies the permissions to create (with `terraform plan/apply`) and delete (with `terraform destroy`) all the required resources in the accepter AWS account

<details><summary>Show IAM Policy</summary>

```js
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateRoute",
        "ec2:DeleteRoute"
      ],
      "Resource": "arn:aws:ec2:*:YYYYYYYY:route-table/*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeVpcPeeringConnections",
        "ec2:DescribeVpcs",
        "ec2:ModifyVpcPeeringConnectionOptions",
        "ec2:DescribeSubnets",
        "ec2:DescribeVpcAttribute",
        "ec2:DescribeRouteTables"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:AcceptVpcPeeringConnection",
        "ec2:DeleteVpcPeeringConnection",
        "ec2:CreateVpcPeeringConnection",
        "ec2:RejectVpcPeeringConnection"
      ],
      "Resource": [
        "arn:aws:ec2:*:YYYYYYYY:vpc-peering-connection/*",
        "arn:aws:ec2:*:YYYYYYYY:vpc/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DeleteTags",
        "ec2:CreateTags"
      ],
      "Resource": "arn:aws:ec2:*:YYYYYYYY:vpc-peering-connection/*"
    }
  ]
}
```

</details>

where `YYYYYYYY` is the accepter AWS account ID.

For more information on IAM policies and permissions for VPC peering, see [Creating and managing VPC peering connections](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_IAM.html#vpcpeeringiam).






<!-- markdownlint-disable -->
## Makefile Targets
```text
Available targets:

  help                                Help screen
  help/all                            Display help for all targets
  help/short                          This help short screen
  lint                                Lint terraform code

```
<!-- markdownlint-restore -->
<!-- markdownlint-disable -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| aws | >= 2.0 |
| null | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| aws.accepter | >= 2.0 |
| aws.requester | >= 2.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| accepter\_allow\_remote\_vpc\_dns\_resolution | Allow accepter VPC to resolve public DNS hostnames to private IP addresses when queried from instances in the requester VPC | `bool` | `true` | no |
| accepter\_aws\_assume\_role\_arn | Accepter AWS Assume Role ARN | `string` | n/a | yes |
| accepter\_region | Accepter AWS region | `string` | n/a | yes |
| accepter\_subnet\_tags | Only add peer routes to accepter VPC route tables of subnets matching these tags | `map(string)` | `{}` | no |
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
| requester\_subnet\_tags | Only add peer routes to requester VPC route tables of subnets matching these tags | `map(string)` | `{}` | no |
| requester\_vpc\_id | Requester VPC ID filter | `string` | `""` | no |
| requester\_vpc\_tags | Requester VPC Tags filter | `map(string)` | `{}` | no |
| skip\_metadata\_api\_check | Don't use the credentials of EC2 instance profile | `bool` | `false` | no |
| stage | Stage (e.g. `prod`, `dev`, `staging`) | `string` | n/a | yes |
| tags | Additional tags (e.g. `{"BusinessUnit" = "XYZ"`) | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| accepter\_accept\_status | Accepter VPC peering connection request status |
| accepter\_connection\_id | Accepter VPC peering connection ID |
| requester\_accept\_status | Requester VPC peering connection request status |
| requester\_connection\_id | Requester VPC peering connection ID |

<!-- markdownlint-restore -->



## Share the Love

Like this project? Please give it a ★ on [our GitHub](https://github.com/cloudposse/terraform-aws-vpc-peering-multi-account)! (it helps us **a lot**)

Are you using this project or any of our other projects? Consider [leaving a testimonial][testimonial]. =)


## Related Projects

Check out these related projects.

- [terraform-aws-vpc](https://github.com/cloudposse/terraform-aws-vpc) - Terraform Module that defines a VPC with public/private subnets across multiple AZs with Internet Gateways
- [terraform-aws-vpc-peering](https://github.com/cloudposse/terraform-aws-vpc) - Terraform module to create a peering connection between two VPCs in the same AWS account
- [terraform-aws-kops-vpc-peering](https://github.com/cloudposse/terraform-aws-kops-vpc-peering) - Terraform module to create a peering connection between a backing services VPC and a VPC created by Kops




## References

For additional context, refer to some of these links.

- [What is VPC Peering?](https://docs.aws.amazon.com/vpc/latest/peering/what-is-vpc-peering.html) - VPC peering connection is a networking connection between two VPCs that enables you to route traffic between them using private IPv4 addresses or IPv6 addresses.


## Help

**Got a question?** We got answers.

File a GitHub [issue](https://github.com/cloudposse/terraform-aws-vpc-peering-multi-account/issues), send us an [email][email] or join our [Slack Community][slack].

[![README Commercial Support][readme_commercial_support_img]][readme_commercial_support_link]

## DevOps Accelerator for Startups


We are a [**DevOps Accelerator**][commercial_support]. We'll help you build your cloud infrastructure from the ground up so you can own it. Then we'll show you how to operate it and stick around for as long as you need us.

[![Learn More](https://img.shields.io/badge/learn%20more-success.svg?style=for-the-badge)][commercial_support]

Work directly with our team of DevOps experts via email, slack, and video conferencing.

We deliver 10x the value for a fraction of the cost of a full-time engineer. Our track record is not even funny. If you want things done right and you need it done FAST, then we're your best bet.

- **Reference Architecture.** You'll get everything you need from the ground up built using 100% infrastructure as code.
- **Release Engineering.** You'll have end-to-end CI/CD with unlimited staging environments.
- **Site Reliability Engineering.** You'll have total visibility into your apps and microservices.
- **Security Baseline.** You'll have built-in governance with accountability and audit logs for all changes.
- **GitOps.** You'll be able to operate your infrastructure via Pull Requests.
- **Training.** You'll receive hands-on training so your team can operate what we build.
- **Questions.** You'll have a direct line of communication between our teams via a Shared Slack channel.
- **Troubleshooting.** You'll get help to triage when things aren't working.
- **Code Reviews.** You'll receive constructive feedback on Pull Requests.
- **Bug Fixes.** We'll rapidly work with you to fix any bugs in our projects.

## Slack Community

Join our [Open Source Community][slack] on Slack. It's **FREE** for everyone! Our "SweetOps" community is where you get to talk with others who share a similar vision for how to rollout and manage infrastructure. This is the best place to talk shop, ask questions, solicit feedback, and work together as a community to build totally *sweet* infrastructure.

## Discourse Forums

Participate in our [Discourse Forums][discourse]. Here you'll find answers to commonly asked questions. Most questions will be related to the enormous number of projects we support on our GitHub. Come here to collaborate on answers, find solutions, and get ideas about the products and services we value. It only takes a minute to get started! Just sign in with SSO using your GitHub account.

## Newsletter

Sign up for [our newsletter][newsletter] that covers everything on our technology radar.  Receive updates on what we're up to on GitHub as well as awesome new projects we discover.

## Office Hours

[Join us every Wednesday via Zoom][office_hours] for our weekly "Lunch & Learn" sessions. It's **FREE** for everyone!

[![zoom](https://img.cloudposse.com/fit-in/200x200/https://cloudposse.com/wp-content/uploads/2019/08/Powered-by-Zoom.png")][office_hours]

## Contributing

### Bug Reports & Feature Requests

Please use the [issue tracker](https://github.com/cloudposse/terraform-aws-vpc-peering-multi-account/issues) to report any bugs or file feature requests.

### Developing

If you are interested in being a contributor and want to get involved in developing this project or [help out](https://cpco.io/help-out) with our other projects, we would love to hear from you! Shoot us an [email][email].

In general, PRs are welcome. We follow the typical "fork-and-pull" Git workflow.

 1. **Fork** the repo on GitHub
 2. **Clone** the project to your own machine
 3. **Commit** changes to your own branch
 4. **Push** your work back up to your fork
 5. Submit a **Pull Request** so that we can review your changes

**NOTE:** Be sure to merge the latest changes from "upstream" before making a pull request!


## Copyright

Copyright © 2017-2020 [Cloud Posse, LLC](https://cpco.io/copyright)



## License

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

See [LICENSE](LICENSE) for full details.

```text
Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at

  https://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License.
```









## Trademarks

All other trademarks referenced herein are the property of their respective owners.

## About

This project is maintained and funded by [Cloud Posse, LLC][website]. Like it? Please let us know by [leaving a testimonial][testimonial]!

[![Cloud Posse][logo]][website]

We're a [DevOps Professional Services][hire] company based in Los Angeles, CA. We ❤️  [Open Source Software][we_love_open_source].

We offer [paid support][commercial_support] on all of our projects.

Check out [our other projects][github], [follow us on twitter][twitter], [apply for a job][jobs], or [hire us][hire] to help with your cloud strategy and implementation.



### Contributors

|  [![Andriy Knysh][aknysh_avatar]][aknysh_homepage]<br/>[Andriy Knysh][aknysh_homepage] | [![Erik Osterman][osterman_avatar]][osterman_homepage]<br/>[Erik Osterman][osterman_homepage] |
|---|---|

  [aknysh_homepage]: https://github.com/aknysh
  [aknysh_avatar]: https://img.cloudposse.com/150x150/https://github.com/aknysh.png
  [osterman_homepage]: https://github.com/osterman
  [osterman_avatar]: https://img.cloudposse.com/150x150/https://github.com/osterman.png

[![README Footer][readme_footer_img]][readme_footer_link]
[![Beacon][beacon]][website]

  [logo]: https://cloudposse.com/logo-300x69.svg
  [docs]: https://cpco.io/docs?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-vpc-peering-multi-account&utm_content=docs
  [website]: https://cpco.io/homepage?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-vpc-peering-multi-account&utm_content=website
  [github]: https://cpco.io/github?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-vpc-peering-multi-account&utm_content=github
  [jobs]: https://cpco.io/jobs?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-vpc-peering-multi-account&utm_content=jobs
  [hire]: https://cpco.io/hire?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-vpc-peering-multi-account&utm_content=hire
  [slack]: https://cpco.io/slack?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-vpc-peering-multi-account&utm_content=slack
  [linkedin]: https://cpco.io/linkedin?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-vpc-peering-multi-account&utm_content=linkedin
  [twitter]: https://cpco.io/twitter?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-vpc-peering-multi-account&utm_content=twitter
  [testimonial]: https://cpco.io/leave-testimonial?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-vpc-peering-multi-account&utm_content=testimonial
  [office_hours]: https://cloudposse.com/office-hours?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-vpc-peering-multi-account&utm_content=office_hours
  [newsletter]: https://cpco.io/newsletter?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-vpc-peering-multi-account&utm_content=newsletter
  [discourse]: https://ask.sweetops.com/?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-vpc-peering-multi-account&utm_content=discourse
  [email]: https://cpco.io/email?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-vpc-peering-multi-account&utm_content=email
  [commercial_support]: https://cpco.io/commercial-support?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-vpc-peering-multi-account&utm_content=commercial_support
  [we_love_open_source]: https://cpco.io/we-love-open-source?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-vpc-peering-multi-account&utm_content=we_love_open_source
  [terraform_modules]: https://cpco.io/terraform-modules?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-vpc-peering-multi-account&utm_content=terraform_modules
  [readme_header_img]: https://cloudposse.com/readme/header/img
  [readme_header_link]: https://cloudposse.com/readme/header/link?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-vpc-peering-multi-account&utm_content=readme_header_link
  [readme_footer_img]: https://cloudposse.com/readme/footer/img
  [readme_footer_link]: https://cloudposse.com/readme/footer/link?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-vpc-peering-multi-account&utm_content=readme_footer_link
  [readme_commercial_support_img]: https://cloudposse.com/readme/commercial-support/img
  [readme_commercial_support_link]: https://cloudposse.com/readme/commercial-support/link?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-vpc-peering-multi-account&utm_content=readme_commercial_support_link
  [share_twitter]: https://twitter.com/intent/tweet/?text=terraform-aws-vpc-peering-multi-account&url=https://github.com/cloudposse/terraform-aws-vpc-peering-multi-account
  [share_linkedin]: https://www.linkedin.com/shareArticle?mini=true&title=terraform-aws-vpc-peering-multi-account&url=https://github.com/cloudposse/terraform-aws-vpc-peering-multi-account
  [share_reddit]: https://reddit.com/submit/?url=https://github.com/cloudposse/terraform-aws-vpc-peering-multi-account
  [share_facebook]: https://facebook.com/sharer/sharer.php?u=https://github.com/cloudposse/terraform-aws-vpc-peering-multi-account
  [share_googleplus]: https://plus.google.com/share?url=https://github.com/cloudposse/terraform-aws-vpc-peering-multi-account
  [share_email]: mailto:?subject=terraform-aws-vpc-peering-multi-account&body=https://github.com/cloudposse/terraform-aws-vpc-peering-multi-account
  [beacon]: https://ga-beacon.cloudposse.com/UA-76589703-4/cloudposse/terraform-aws-vpc-peering-multi-account?pixel&cs=github&cm=readme&an=terraform-aws-vpc-peering-multi-account
