variable "create_opensearch" {
  description = "Controls if Opensearch should be created (if affects almost all resources)"
  type        = bool
  default     = true
}

variable "domain_name" {
  description = "Name of the domain."
  type        = string
  default     = "opensearch"
}

variable "engine_version" {
  description = "Either `Elasticsearch_X.Y` or `OpenSearch_X.Y` to specify the engine version for the Amazon OpenSearch Service domain."
  type        = string
  default     = "OpenSearch_1.1"
}

variable "advanced_options" {
  description = "Key-value string pairs to specify advanced configuration options."
  type        = map(string)
  default     = {}
}

variable "advanced_security_options_enabled" {
  description = "Whether advanced security is enabled."
  type        = bool
  default     = false
}

variable "advanced_security_options_internal_user_db_enabled" {
  description = "Whether the internal user database is enabled."
  type        = bool
  default     = false
}

variable "advanced_security_options_master_user_arn" {
  description = "ARN for the main user. Only specify if `internal_user_database_enabled` is not set or set to `false`."
  type        = string
  default     = ""
}

variable "advanced_security_options_master_user_name" {
  description = "Main user's username, which is stored in the Amazon OpenSearch Service domain's internal database."
  type        = string
  default     = ""
}

variable "advanced_security_options_master_user_password" {
  description = "Main user's password, which is stored in the Amazon OpenSearch Service domain's internal database."
  type        = string
  default     = ""
}

variable "ebs_volume_size" {
  description = "Size of EBS volumes attached to data nodes (in GiB)."
  type        = number
  default     = 0
}


variable "volume_type" {
  description = "Type of EBS volumes attached to data nodes."
  type        = string
  default     = "gp2"
}

variable "ebs_iops" {
  description = "Baseline input/output (I/O) performance of EBS volumes attached to data nodes."
  type        = number
  default     = 0
}

variable "encrypt_at_rest_enabled" {
  description = "Whether to enable encryption at rest."
  type        = bool
  default     = true
}

variable "encrypt_at_rest_kms_key_id" {
  description = "KMS key ARN to encrypt the Opensearch domain with."
  type        = string
  default     = ""
}

variable "domain_endpoint_options_enforce_https" {
  description = "Whether or not to require HTTPS."
  type        = bool
  default     = true
}

variable "domain_endpoint_options_tls_security_policy" {
  description = "Name of the TLS security policy that needs to be applied to the HTTPS endpoint."
  type        = string
  default     = "Policy-Min-TLS-1-0-2019-07"
}

variable "custom_endpoint_enabled" {
  description = "Whether to enable custom endpoint for the OpenSearch domain."
  type        = bool
  default     = false
}

variable "custom_endpoint_certificate_arn" {
  description = "ACM certificate ARN for your custom endpoint."
  type        = string
  default     = ""
}

variable "custom_endpoint" {
  description = "Fully qualified domain for your custom endpoint."
  type        = string
  default     = ""
}

variable "instance_count" {
  description = "Number of instances in the cluster."
  type        = number
  default     = 4
}

variable "instance_type" {
  description = "Instance type of data nodes in the cluster."
  type        = string
  default     = "t3.small.search"
}

variable "dedicated_master_enabled" {
  description = "Whether dedicated main nodes are enabled for the cluster."
  type        = bool
  default     = false
}

variable "dedicated_master_count" {
  description = "Number of dedicated main nodes in the cluster."
  type        = number
  default     = 0
}

variable "dedicated_master_type" {
  description = "Instance type of the dedicated main nodes in the cluster."
  type        = string
  default     = "t3.small.search"
}

variable "zone_awareness_enabled" {
  description = "Whether zone awareness is enabled, set to true for multi-az deployment."
  type        = bool
  default     = true
}

variable "warm_enabled" {
  description = "Whether to enable warm storage."
  type        = bool
  default     = false
}

variable "warm_count" {
  description = "Number of warm nodes in the cluster."
  type        = number
  default     = 2
}

variable "warm_type" {
  description = "Instance type for the OpenSearch cluster's warm nodes."
  type        = string
  default     = "ultrawarm1.medium.search"
}

variable "availability_zone_count" {
  description = "Number of Availability Zones for the domain to use with `zone_awareness_enabled`."
  type        = number
  default     = 2

  validation {
    condition     = contains([2, 3], var.availability_zone_count)
    error_message = "Availability zone count must be 2 or 3"
  }
}

variable "node_to_node_encryption_enabled" {
  description = "Whether to enable node-to-node encryption."
  type        = bool
  default     = false
}

variable "vpc_enabled" {
  description = "Whether to enable VPC configurations."
  type        = bool
  default     = true
}

variable "subnet_ids" {
  description = "List of VPC Subnet IDs for the OpenSearch domain endpoints to be created in."
  type        = list(string)
  default     = []
}

variable "automated_snapshot_start_hour" {
  description = "Hour during which the service takes an automated daily snapshot of the indices in the domain."
  type        = number
  default     = 0
}

variable "cognito_authentication_enabled" {
  description = "Whether to enable Congito authentication."
  type        = bool
  default     = false
}

variable "cognito_user_pool_id" {
  description = "ID of the Cognito User Pool to use."
  type        = string
  default     = ""
}

variable "congito_identity_pool_id" {
  description = "ID of the Cognito Identity Pool to use."
  type        = string
  default     = ""
}

variable "cognito_iam_role_arn" {
  description = "ARN of the IAM role that has the AmazonOpenSearchServiceCognitoAccess policy attached."
  type        = string
  default     = ""
}

variable "log_publishing_index_enabled" {
  description = "Whether given log publishing option for `INDEX_SLOW_LOGS` is enabled or not."
  type        = bool
  default     = false
}

variable "log_publishing_index_cloudwatch_log_group_arn" {
  description = "ARN of the CloudWatch log group to which log for `INDEX_SLOW_LOGS` needs to be published"
  type        = string
  default     = ""
}

variable "log_publishing_search_enabled" {
  description = "Whether given log publishing option for `SEARCH_SLOW_LOGS` is enabled or not."
  type        = bool
  default     = false
}

variable "log_publishing_search_cloudwatch_log_group_arn" {
  description = "ARN of the CloudWatch log group to which log for `SEARCH_SLOW_LOGS` needs to be published"
  type        = string
  default     = ""
}

variable "log_publishing_audit_enabled" {
  description = "Whether given log publishing option for `AUDIT_LOGS` is enabled or not."
  type        = bool
  default     = false
}

variable "log_publishing_audit_cloudwatch_log_group_arn" {
  description = "ARN of the CloudWatch log group to which log for `AUDIT_LOGS` needs to be published"
  type        = string
  default     = ""
}

variable "log_publishing_application_enabled" {
  description = "Whether given log publishing option for `ES_APPLICATION_LOGS` is enabled or not."
  type        = bool
  default     = false
}

variable "log_publishing_application_cloudwatch_log_group_arn" {
  description = "ARN of the CloudWatch log group to which log for `ES_APPLICATION_LOGS` needs to be published"
  type        = string
  default     = ""
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

##

variable "create_iam_service_linked_role" {
  description = "Whether to create `AWSServiceRoleForAmazonOpensearchService` service-linked role. Set it to `false` if you already have an Opensearch cluster created in the AWS account and AWSServiceRoleForAmazonOpensearchService already exists. See https://github.com/terraform-providers/terraform-provider-aws/issues/5218 for more info"
  type        = bool
  default     = true
}

variable "iam_authorizing_role_arns" {
  description = "List of IAM role ARNs to permit to assume the Opensearch user role"
  type        = list(string)
  default     = []
}

variable "opensearch_role_tags" {
  description = "A map of tags to add to Opensearch User role"
  type        = map(string)
  default     = {}
}

variable "iam_role_arns" {
  description = "List of IAM role ARNs to permit access to the Opensearch domain"
  type        = list(string)
  default     = []
}

variable "aws_ec2_service_name" {
  description = "AWS EC2 Service Name"
  type        = list(string)
  default     = ["ec2.amazonaws.com"]
}

variable "iam_actions" {
  description = "List of actions to allow for the IAM roles, _e.g._ `es:ESHttpGet`, `es:ESHttpPut`, `es:ESHttpPost`"
  type        = list(string)
  default     = []
}

variable "iam_role_max_session_duration" {
    description = "Maximum session duration (in seconds) that you want to set for the specified role."
    type = number
    default = 3600
}

variable "iam_role_permissions_boundary" {
    description = "ARN of the policy that is used to set the permissions boundary for the role."
    type = string
    default = "The ARN of the permissions boundary policy which will be attached to the Opensearch user role."
}

variable "allowed_cidr_blocks" {
  description = "List of CIDR blocks to be allowed to connect to the cluster"
  type        = list(string)
  default     = []
}

variable "vpc_id" {
  description = "ID of the VPC where the cluster security group will be provisioned"
  type        = string
  default     = null
}

variable "opensearch_security_group_use_name_prefix" {
  description = "Determines whether Opensearch security group name (`opensearch_security_group_name`) is used as a prefix"
  type        = bool
  default     = true
}

variable "opensearch_security_group_rules" {
  description = "List of security group rules to add to the Opensearch security group created."
  type        = any
  default     = {}
}

variable "prefix_separator" {
  description = "The separator to use between the prefix and the generated timestamp for resource names"
  type        = string
  default     = "-"
}

variable "opensearch_security_group_name" {
  description = "Name to use on cluster security group created"
  type        = string
  default     = null
}


variable "sg_tags" {
  description = "A map of tags to add to Openserach Security Group"
  type        = map(string)
  default     = {}
}

