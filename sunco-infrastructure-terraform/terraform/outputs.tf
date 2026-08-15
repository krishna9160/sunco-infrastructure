output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "app_subnet_ids" {
  value = module.vpc.app_subnet_ids
}

output "db_subnet_ids" {
  value = module.vpc.db_subnet_ids
}

output "alb_security_group_id" {
  value = module.vpc.alb_security_group_id
}

output "db_security_group_id" {
  value = module.vpc.db_security_group_id
}

output "ecr_repository_url" {
  description = "Sunco ECR repository URL"
  value       = module.ecr.repository_url
}

output "bucket_name" {
  value = module.s3.bucket_name
}

output "bucket_arn" {
  value = module.s3.bucket_arn
}
