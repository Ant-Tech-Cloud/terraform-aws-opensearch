# terraform-aws-opensearch
Terraform module to provision an [`Opensearch`](https://aws.amazon.com/opensearch-service/) cluster with built-in integrations with [Kibana](https://aws.amazon.com/elasticsearch-service/kibana/) and [Logstash](https://aws.amazon.com/elasticsearch-service/logstash/).

## Introduction

This module will create:
- Opensearch cluster with the specified node count in the provided subnets in a VPC
- Opensearch domain policy that accepts a list of IAM role ARNs from which to permit management traffic to the cluster
- Security Group to control access to the opensearch domain

__NOTE:__ To enable [zone awareness](https://docs.aws.amazon.com/elasticsearch-service/latest/developerguide/es-managedomains.html#es-managedomains-zoneawareness) to deploy Opensearch nodes into two different Availability Zones, you need to set `zone_awareness_enabled` to `true` and provide two different subnets in `subnet_ids`.
If you enable zone awareness for your domain, Amazon Opensearch places an endpoint into two subnets.
The subnets must be in different Availability Zones in the same region.
If you don't enable zone awareness, Amazon Opensearch places an endpoint into only one subnet. You also need to set `availability_zone_count` to `1`.

## Usage
``` terraform
module "opensearch" {
  source = "Ant-Tech-Cloud/opensearch/aws"
  # version     = "x.x.x"

  domain_name             = "opensearch"
  vpc_id                  = "vpc-XXXXXXXXX"
  subnet_ids              = ["subnet-XXXXXXXXX", "subnet-ZZZZZZZ"]
  zone_awareness_enabled  = "true"
  engine_version          = "OpenSearch_2.3"
  instance_type           = "t2.small.search"
  instance_count          = 4
  ebs_volume_size         = 10
  iam_actions             = ["es:ESHttpGet", "es:ESHttpPut", "es:ESHttpPost"]
  encrypt_at_rest_enabled = true

  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.opensearch_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_service_linked_role.opensearch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_service_linked_role) | resource |
| [aws_opensearch_domain.opensearch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearch_domain) | resource |
| [aws_opensearch_domain_policy.opensearch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearch_domain_policy) | resource |
| [aws_security_group.opensearch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.opensearch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.opensearch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_advanced_options"></a> [advanced\_options](#input\_advanced\_options) | Key-value string pairs to specify advanced configuration options. | `map(string)` | `{}` | no |
| <a name="input_advanced_security_options_enabled"></a> [advanced\_security\_options\_enabled](#input\_advanced\_security\_options\_enabled) | Whether advanced security is enabled. | `bool` | `false` | no |
| <a name="input_advanced_security_options_internal_user_db_enabled"></a> [advanced\_security\_options\_internal\_user\_db\_enabled](#input\_advanced\_security\_options\_internal\_user\_db\_enabled) | Whether the internal user database is enabled. | `bool` | `false` | no |
| <a name="input_advanced_security_options_master_user_arn"></a> [advanced\_security\_options\_master\_user\_arn](#input\_advanced\_security\_options\_master\_user\_arn) | ARN for the main user. Only specify if `internal_user_database_enabled` is not set or set to `false`. | `string` | `""` | no |
| <a name="input_advanced_security_options_master_user_name"></a> [advanced\_security\_options\_master\_user\_name](#input\_advanced\_security\_options\_master\_user\_name) | Main user's username, which is stored in the Amazon OpenSearch Service domain's internal database. | `string` | `""` | no |
| <a name="input_advanced_security_options_master_user_password"></a> [advanced\_security\_options\_master\_user\_password](#input\_advanced\_security\_options\_master\_user\_password) | Main user's password, which is stored in the Amazon OpenSearch Service domain's internal database. | `string` | `""` | no |
| <a name="input_allowed_cidr_blocks"></a> [allowed\_cidr\_blocks](#input\_allowed\_cidr\_blocks) | List of CIDR blocks to be allowed to connect to the cluster | `list(string)` | `[]` | no |
| <a name="input_automated_snapshot_start_hour"></a> [automated\_snapshot\_start\_hour](#input\_automated\_snapshot\_start\_hour) | Hour during which the service takes an automated daily snapshot of the indices in the domain. | `number` | `0` | no |
| <a name="input_availability_zone_count"></a> [availability\_zone\_count](#input\_availability\_zone\_count) | Number of Availability Zones for the domain to use with `zone_awareness_enabled`. | `number` | `2` | no |
| <a name="input_aws_ec2_service_name"></a> [aws\_ec2\_service\_name](#input\_aws\_ec2\_service\_name) | AWS EC2 Service Name | `list(string)` | <pre>[<br>  "ec2.amazonaws.com"<br>]</pre> | no |
| <a name="input_cognito_authentication_enabled"></a> [cognito\_authentication\_enabled](#input\_cognito\_authentication\_enabled) | Whether to enable Congito authentication. | `bool` | `false` | no |
| <a name="input_cognito_iam_role_arn"></a> [cognito\_iam\_role\_arn](#input\_cognito\_iam\_role\_arn) | ARN of the IAM role that has the AmazonOpenSearchServiceCognitoAccess policy attached. | `string` | `""` | no |
| <a name="input_cognito_user_pool_id"></a> [cognito\_user\_pool\_id](#input\_cognito\_user\_pool\_id) | ID of the Cognito User Pool to use. | `string` | `""` | no |
| <a name="input_congito_identity_pool_id"></a> [congito\_identity\_pool\_id](#input\_congito\_identity\_pool\_id) | ID of the Cognito Identity Pool to use. | `string` | `""` | no |
| <a name="input_create_iam_service_linked_role"></a> [create\_iam\_service\_linked\_role](#input\_create\_iam\_service\_linked\_role) | Whether to create `AWSServiceRoleForAmazonOpensearchService` service-linked role. Set it to `false` if you already have an Opensearch cluster created in the AWS account and AWSServiceRoleForAmazonOpensearchService already exists. See https://github.com/terraform-providers/terraform-provider-aws/issues/5218 for more info | `bool` | `true` | no |
| <a name="input_create_opensearch"></a> [create\_opensearch](#input\_create\_opensearch) | Controls if Opensearch should be created (if affects almost all resources) | `bool` | `true` | no |
| <a name="input_custom_endpoint"></a> [custom\_endpoint](#input\_custom\_endpoint) | Fully qualified domain for your custom endpoint. | `string` | `""` | no |
| <a name="input_custom_endpoint_certificate_arn"></a> [custom\_endpoint\_certificate\_arn](#input\_custom\_endpoint\_certificate\_arn) | ACM certificate ARN for your custom endpoint. | `string` | `""` | no |
| <a name="input_custom_endpoint_enabled"></a> [custom\_endpoint\_enabled](#input\_custom\_endpoint\_enabled) | Whether to enable custom endpoint for the OpenSearch domain. | `bool` | `false` | no |
| <a name="input_dedicated_master_count"></a> [dedicated\_master\_count](#input\_dedicated\_master\_count) | Number of dedicated main nodes in the cluster. | `number` | `0` | no |
| <a name="input_dedicated_master_enabled"></a> [dedicated\_master\_enabled](#input\_dedicated\_master\_enabled) | Whether dedicated main nodes are enabled for the cluster. | `bool` | `false` | no |
| <a name="input_dedicated_master_type"></a> [dedicated\_master\_type](#input\_dedicated\_master\_type) | Instance type of the dedicated main nodes in the cluster. | `string` | `"t3.small.search"` | no |
| <a name="input_domain_endpoint_options_enforce_https"></a> [domain\_endpoint\_options\_enforce\_https](#input\_domain\_endpoint\_options\_enforce\_https) | Whether or not to require HTTPS. | `bool` | `true` | no |
| <a name="input_domain_endpoint_options_tls_security_policy"></a> [domain\_endpoint\_options\_tls\_security\_policy](#input\_domain\_endpoint\_options\_tls\_security\_policy) | Name of the TLS security policy that needs to be applied to the HTTPS endpoint. | `string` | `"Policy-Min-TLS-1-0-2019-07"` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Name of the domain. | `string` | `"opensearch"` | no |
| <a name="input_ebs_iops"></a> [ebs\_iops](#input\_ebs\_iops) | Baseline input/output (I/O) performance of EBS volumes attached to data nodes. | `number` | `0` | no |
| <a name="input_ebs_volume_size"></a> [ebs\_volume\_size](#input\_ebs\_volume\_size) | Size of EBS volumes attached to data nodes (in GiB). | `number` | `0` | no |
| <a name="input_encrypt_at_rest_enabled"></a> [encrypt\_at\_rest\_enabled](#input\_encrypt\_at\_rest\_enabled) | Whether to enable encryption at rest. | `bool` | `true` | no |
| <a name="input_encrypt_at_rest_kms_key_id"></a> [encrypt\_at\_rest\_kms\_key\_id](#input\_encrypt\_at\_rest\_kms\_key\_id) | KMS key ARN to encrypt the Opensearch domain with. | `string` | `""` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | Either `Elasticsearch_X.Y` or `OpenSearch_X.Y` to specify the engine version for the Amazon OpenSearch Service domain. | `string` | `"OpenSearch_1.1"` | no |
| <a name="input_iam_actions"></a> [iam\_actions](#input\_iam\_actions) | List of actions to allow for the IAM roles, _e.g._ `es:ESHttpGet`, `es:ESHttpPut`, `es:ESHttpPost` | `list(string)` | `[]` | no |
| <a name="input_iam_authorizing_role_arns"></a> [iam\_authorizing\_role\_arns](#input\_iam\_authorizing\_role\_arns) | List of IAM role ARNs to permit to assume the Opensearch user role | `list(string)` | `[]` | no |
| <a name="input_iam_role_arns"></a> [iam\_role\_arns](#input\_iam\_role\_arns) | List of IAM role ARNs to permit access to the Opensearch domain | `list(string)` | `[]` | no |
| <a name="input_iam_role_max_session_duration"></a> [iam\_role\_max\_session\_duration](#input\_iam\_role\_max\_session\_duration) | Maximum session duration (in seconds) that you want to set for the specified role. | `number` | `3600` | no |
| <a name="input_iam_role_permissions_boundary"></a> [iam\_role\_permissions\_boundary](#input\_iam\_role\_permissions\_boundary) | ARN of the policy that is used to set the permissions boundary for the role. | `string` | `"The ARN of the permissions boundary policy which will be attached to the Opensearch user role."` | no |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | Number of instances in the cluster. | `number` | `4` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type of data nodes in the cluster. | `string` | `"t3.small.search"` | no |
| <a name="input_log_publishing_application_cloudwatch_log_group_arn"></a> [log\_publishing\_application\_cloudwatch\_log\_group\_arn](#input\_log\_publishing\_application\_cloudwatch\_log\_group\_arn) | ARN of the CloudWatch log group to which log for `ES_APPLICATION_LOGS` needs to be published | `string` | `""` | no |
| <a name="input_log_publishing_application_enabled"></a> [log\_publishing\_application\_enabled](#input\_log\_publishing\_application\_enabled) | Whether given log publishing option for `ES_APPLICATION_LOGS` is enabled or not. | `bool` | `false` | no |
| <a name="input_log_publishing_audit_cloudwatch_log_group_arn"></a> [log\_publishing\_audit\_cloudwatch\_log\_group\_arn](#input\_log\_publishing\_audit\_cloudwatch\_log\_group\_arn) | ARN of the CloudWatch log group to which log for `AUDIT_LOGS` needs to be published | `string` | `""` | no |
| <a name="input_log_publishing_audit_enabled"></a> [log\_publishing\_audit\_enabled](#input\_log\_publishing\_audit\_enabled) | Whether given log publishing option for `AUDIT_LOGS` is enabled or not. | `bool` | `false` | no |
| <a name="input_log_publishing_index_cloudwatch_log_group_arn"></a> [log\_publishing\_index\_cloudwatch\_log\_group\_arn](#input\_log\_publishing\_index\_cloudwatch\_log\_group\_arn) | ARN of the CloudWatch log group to which log for `INDEX_SLOW_LOGS` needs to be published | `string` | `""` | no |
| <a name="input_log_publishing_index_enabled"></a> [log\_publishing\_index\_enabled](#input\_log\_publishing\_index\_enabled) | Whether given log publishing option for `INDEX_SLOW_LOGS` is enabled or not. | `bool` | `false` | no |
| <a name="input_log_publishing_search_cloudwatch_log_group_arn"></a> [log\_publishing\_search\_cloudwatch\_log\_group\_arn](#input\_log\_publishing\_search\_cloudwatch\_log\_group\_arn) | ARN of the CloudWatch log group to which log for `SEARCH_SLOW_LOGS` needs to be published | `string` | `""` | no |
| <a name="input_log_publishing_search_enabled"></a> [log\_publishing\_search\_enabled](#input\_log\_publishing\_search\_enabled) | Whether given log publishing option for `SEARCH_SLOW_LOGS` is enabled or not. | `bool` | `false` | no |
| <a name="input_node_to_node_encryption_enabled"></a> [node\_to\_node\_encryption\_enabled](#input\_node\_to\_node\_encryption\_enabled) | Whether to enable node-to-node encryption. | `bool` | `false` | no |
| <a name="input_opensearch_role_tags"></a> [opensearch\_role\_tags](#input\_opensearch\_role\_tags) | A map of tags to add to Opensearch User role | `map(string)` | `{}` | no |
| <a name="input_opensearch_security_group_name"></a> [opensearch\_security\_group\_name](#input\_opensearch\_security\_group\_name) | Name to use on cluster security group created | `string` | `null` | no |
| <a name="input_opensearch_security_group_rules"></a> [opensearch\_security\_group\_rules](#input\_opensearch\_security\_group\_rules) | List of security group rules to add to the Opensearch security group created. | `any` | `{}` | no |
| <a name="input_opensearch_security_group_use_name_prefix"></a> [opensearch\_security\_group\_use\_name\_prefix](#input\_opensearch\_security\_group\_use\_name\_prefix) | Determines whether Opensearch security group name (`opensearch_security_group_name`) is used as a prefix | `bool` | `true` | no |
| <a name="input_prefix_separator"></a> [prefix\_separator](#input\_prefix\_separator) | The separator to use between the prefix and the generated timestamp for resource names | `string` | `"-"` | no |
| <a name="input_sg_tags"></a> [sg\_tags](#input\_sg\_tags) | A map of tags to add to Openserach Security Group | `map(string)` | `{}` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of VPC Subnet IDs for the OpenSearch domain endpoints to be created in. | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_volume_type"></a> [volume\_type](#input\_volume\_type) | Type of EBS volumes attached to data nodes. | `string` | `"gp2"` | no |
| <a name="input_vpc_enabled"></a> [vpc\_enabled](#input\_vpc\_enabled) | Whether to enable VPC configurations. | `bool` | `true` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC where the cluster security group will be provisioned | `string` | `null` | no |
| <a name="input_warm_count"></a> [warm\_count](#input\_warm\_count) | Number of warm nodes in the cluster. | `number` | `2` | no |
| <a name="input_warm_enabled"></a> [warm\_enabled](#input\_warm\_enabled) | Whether to enable warm storage. | `bool` | `false` | no |
| <a name="input_warm_type"></a> [warm\_type](#input\_warm\_type) | Instance type for the OpenSearch cluster's warm nodes. | `string` | `"ultrawarm1.medium.search"` | no |
| <a name="input_zone_awareness_enabled"></a> [zone\_awareness\_enabled](#input\_zone\_awareness\_enabled) | Whether zone awareness is enabled, set to true for multi-az deployment. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_domain_arn"></a> [domain\_arn](#output\_domain\_arn) | ARN of the Opensearch domain. |
| <a name="output_domain_endpoint"></a> [domain\_endpoint](#output\_domain\_endpoint) | Domain-specific endpoint used to submit index, search, and data upload requests. |
| <a name="output_domain_id"></a> [domain\_id](#output\_domain\_id) | Unique identifier for the domain. |
| <a name="output_domain_name"></a> [domain\_name](#output\_domain\_name) | Name of the OpenSearch domain. |
| <a name="output_kibana_endpoint"></a> [kibana\_endpoint](#output\_kibana\_endpoint) | Domain-specific endpoint for kibana without https scheme. |
| <a name="output_opensearch_security_group_arn"></a> [opensearch\_security\_group\_arn](#output\_opensearch\_security\_group\_arn) | Amazon Resource Name (ARN) of the cluster security group |
| <a name="output_opensearch_security_group_id"></a> [opensearch\_security\_group\_id](#output\_opensearch\_security\_group\_id) | ID of the Opensearch security group |
| <a name="output_opensearch_user_iam_role_arn"></a> [opensearch\_user\_iam\_role\_arn](#output\_opensearch\_user\_iam\_role\_arn) | The ARN of the IAM role to allow access to Opensearch cluster |
| <a name="output_opensearch_user_iam_role_name"></a> [opensearch\_user\_iam\_role\_name](#output\_opensearch\_user\_iam\_role\_name) | The name of the IAM role to allow access to Opensearch cluster |
