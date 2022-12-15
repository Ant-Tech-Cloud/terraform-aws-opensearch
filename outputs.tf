
#========================= Opensearch ============================


output "domain_arn" {
  description = "ARN of the Opensearch domain."
  value       = one(aws_opensearch_domain.opensearch[0].arn)
}

output "domain_id" {
  description = "Unique identifier for the domain."
  value       = one(aws_opensearch_domain.opensearch[0].domain_id)
}

output "domain_name" {
  description = "Name of the OpenSearch domain."
  value       = one(aws_opensearch_domain.opensearch[0].domain_name)
}

output "domain_endpoint" {
  description = "Domain-specific endpoint used to submit index, search, and data upload requests."
  value       = one(aws_opensearch_domain.opensearch[0].endpoint)
}

output "kibana_endpoint" {
  description = "Domain-specific endpoint for kibana without https scheme."
  value       = one(aws_opensearch_domain.opensearch[0].kibana_endpoint)
}

output "opensearch_user_iam_role_name" {
  value       = one(aws_iam_role.opensearch_user[0].name)
  description = "The name of the IAM role to allow access to Opensearch cluster"
}

output "opensearch_user_iam_role_arn" {
  value       = one(aws_iam_role.opensearch_user[0].arn)
  description = "The ARN of the IAM role to allow access to Opensearch cluster"
}

#========================= Security Group ============================

output "opensearch_security_group_arn" {
  description = "Amazon Resource Name (ARN) of the cluster security group"
  value       = try(aws_security_group.opensearch[0].arn, null)
}

output "opensearch_security_group_id" {
  description = "ID of the Opensearch security group"
  value       = try(aws_security_group.opensearch[0].id, null)
}