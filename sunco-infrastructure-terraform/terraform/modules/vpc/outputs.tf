output "vpc_id" {
  description = "ID of Sunco VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = aws_subnet.public[*].id
}

output "app_subnet_ids" {
  description = "IDs of private application subnets"
  value       = aws_subnet.app[*].id
}

output "db_subnet_ids" {
  description = "IDs of private database subnets"
  value       = aws_subnet.db[*].id
}

output "alb_security_group_id" {
  description = "Security group ID for ALB"
  value       = aws_security_group.alb.id
}


output "db_security_group_id" {
  description = "Security group ID for database tier"
  value       = aws_security_group.db.id
}
