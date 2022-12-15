locals {
  cluster_sg_name = coalesce(var.opensearch_security_group_name, "${var.domain_name}-cluster")
}

resource "aws_security_group" "opensearch" {
  count       = var.create_opensearch && var.vpc_enabled ? 1 : 0
  vpc_id      = var.vpc_id
  name        = var.opensearch_security_group_use_name_prefix ? null : local.cluster_sg_name
  name_prefix = var.opensearch_security_group_use_name_prefix ? "${local.cluster_sg_name}${var.prefix_separator}" : null
  description = "Allow inbound traffic. Allow all outbound traffic"
  tags        = merge(var.tags, var.sg_tags)

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "opensearch" {
  for_each = { for i, k in var.opensearch_security_group_rules : i => k if var.vpc_enabled }

  security_group_id = aws_security_group.opensearch[0].id
  protocol          = each.value.protocol
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  type              = each.value.type

  description              = lookup(each.value, "description", null)
  cidr_blocks              = lookup(each.value, "cidr_blocks", null)
  ipv6_cidr_blocks         = lookup(each.value, "ipv6_cidr_blocks", null)
  prefix_list_ids          = lookup(each.value, "prefix_list_ids", null)
  self                     = lookup(each.value, "self", null)
  source_security_group_id = lookup(each.value, "source_security_group_id", null)
}


resource "aws_opensearch_domain" "opensearch" {
  count = var.create_opensearch ? 1 : 0

  domain_name    = var.domain_name
  engine_version = var.engine_version

  advanced_options = var.advanced_options

  advanced_security_options {
    enabled                        = var.advanced_security_options_enabled
    internal_user_database_enabled = var.advanced_security_options_internal_user_db_enabled
    master_user_options {
      master_user_arn      = var.advanced_security_options_master_user_arn
      master_user_name     = var.advanced_security_options_master_user_name
      master_user_password = var.advanced_security_options_master_user_password
    }
  }

  ebs_options {
    ebs_enabled = var.ebs_volume_size > 0 ? true : false
    volume_size = var.ebs_volume_size
    volume_type = var.volume_type
    iops        = var.ebs_iops
  }

  encrypt_at_rest {
    enabled    = var.encrypt_at_rest_enabled
    kms_key_id = var.encrypt_at_rest_kms_key_id
  }

  domain_endpoint_options {
    enforce_https                   = var.domain_endpoint_options_enforce_https
    tls_security_policy             = var.domain_endpoint_options_tls_security_policy
    custom_endpoint                 = var.custom_endpoint_enabled ? var.custom_endpoint : null
    custom_endpoint_certificate_arn = var.custom_endpoint_enabled ? var.custom_endpoint_certificate_arn : null
  }

  cluster_config {
    instance_count           = var.instance_count
    instance_type            = var.instance_type
    dedicated_master_enabled = var.dedicated_master_enabled
    dedicated_master_count   = var.dedicated_master_count
    dedicated_master_type    = var.dedicated_master_type
    zone_awareness_enabled    = var.zone_awareness_enabled
    warm_enabled             = var.warm_enabled
    warm_count               = var.warm_enabled ? var.warm_count : null
    warm_type                = var.warm_enabled ? var.warm_type : null

    dynamic "zone_awareness_config" {
      for_each = var.availability_zone_count > 1 && var.zone_awareness_enabled ? [true] : []
      content {
        availability_zone_count = var.availability_zone_count
      }
    }
  }

  node_to_node_encryption {
    enabled = var.node_to_node_encryption_enabled
  }

  dynamic "vpc_options" {
    for_each = var.vpc_enabled ? [true] : []
    content {
      security_group_ids = [join("", aws_security_group.opensearch[*].id)]
      subnet_ids         = var.subnet_ids
    }
  }

  snapshot_options {
    automated_snapshot_start_hour = var.automated_snapshot_start_hour
  }

  dynamic "cognito_options" {
    for_each = var.cognito_authentication_enabled ? [true] : []
    content {
      enabled          = true
      user_pool_id     = var.cognito_user_pool_id
      identity_pool_id = var.congito_identity_pool_id
      role_arn         = var.cognito_iam_role_arn
    }
  }

  log_publishing_options {
    enabled                  = var.log_publishing_index_enabled
    log_type                 = "INDEX_SLOW_LOGS"
    cloudwatch_log_group_arn = var.log_publishing_index_cloudwatch_log_group_arn
  }

  log_publishing_options {
    enabled                  = var.log_publishing_search_enabled
    log_type                 = "SEARCH_SLOW_LOGS"
    cloudwatch_log_group_arn = var.log_publishing_search_cloudwatch_log_group_arn
  }

  log_publishing_options {
    enabled                  = var.log_publishing_audit_enabled
    log_type                 = "AUDIT_LOGS"
    cloudwatch_log_group_arn = var.log_publishing_audit_cloudwatch_log_group_arn
  }

  log_publishing_options {
    enabled                  = var.log_publishing_application_enabled
    log_type                 = "ES_APPLICATION_LOGS"
    cloudwatch_log_group_arn = var.log_publishing_application_cloudwatch_log_group_arn
  }

  tags = var.tags
}

resource "aws_iam_service_linked_role" "opensearch" {
    count = var.create_opensearch && var.create_iam_service_linked_role ? 1 : 0
    aws_service_name = "es.amazonaws.com"
    description = "AWSServiceRoleForAmazonOpensearchService Service-Linked Role"
}

resource "aws_iam_role" "opensearch_user" {
    count = var.create_opensearch && (length(var.iam_authorizing_role_arns) > 0 || length(var.iam_role_arns) > 0) ? 1 : 0
    name = "opensearch-assume-role"
    assume_role_policy = join("", data.aws_iam_policy_document.assume_role[*].json)
    description = "IAM Role to assume to access the Opensearch ${var.domain_name} cluster"
    tags = merge(var.tags, var.opensearch_role_tags)

    max_session_duration = var.iam_role_max_session_duration

    permissions_boundary = var.iam_role_permissions_boundary
}

data "aws_iam_policy_document" "assume_role" {
    count = var.create_opensearch && (length(var.iam_authorizing_role_arns) > 0 || length(var.iam_role_arns) > 0) ? 1 : 0

    statement {
        actions = [
            "sts:AssumeRole"
        ]

        principals {
            type = "Service"
            identifiers = var.aws_ec2_service_name
        }

        principals {
            type = "AWS"
            identifiers = compact(concat(var.iam_authorizing_role_arns, var.iam_role_arns))
        }

        effect = "Allow"
    }
}

data "aws_iam_policy_document" "opensearch" {
    count = var.create_opensearch && (length(var.iam_authorizing_role_arns) > 0 || length(var.iam_role_arns) > 0) ? 1 : 0

    statement {
        effect = "Allow"

        actions = distinct(compact(var.iam_actions))

        resources = [
            join("", aws_opensearch_domain.opensearch[*].arn),
            "${join("", aws_opensearch_domain.opensearch[*].arn)}/*"
        ]

        principals {
            type = "AWS"
            identifiers = distinct(compact(concat(var.iam_role_arns, aws_iam_role.opensearch_user[*].arn)))
        }
    }

    dynamic "statement" {
        for_each = length(var.allowed_cidr_blocks) > 0 && ! var.vpc_enabled ? [true] : []
        content {
            effect = "Allow"

            actions = distinct(compact(var.iam_actions))

            resources = [
                join("", aws_opensearch_domain.opensearch[*].arn),
                "${join("", aws_opensearch_domain.opensearch[*])}/*"
            ]

            principals {
                type = "AWS"
                identifiers = ["*"]
            }

            condition {
                test = "IpAddress"
                values = var.allowed_cidr_blocks
                variable = "aws:SourceIp"
            }
        }
    }
}

resource "aws_opensearch_domain_policy" "opensearch" {
    count = var.create_opensearch && (length(var.iam_authorizing_role_arns) > 0 || length(var.iam_role_arns) > 0) ? 1 : 0
    domain_name = var.domain_name
    access_policies = join("", data.aws_iam_policy_document.opensearch[*].json)
}