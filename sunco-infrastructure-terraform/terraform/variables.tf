variable "aws_region" {
  description = "AWS region for Sunco infrastructure"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for Sunco VPC"
  type        = string
}

variable "availability_zones" {
  description = "Availability zones for Sunco infrastructure"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDRs for public subnets"
  type        = list(string)
}

variable "app_subnet_cidrs" {
  description = "CIDRs for private application subnets"
  type        = list(string)
}

variable "db_subnet_cidrs" {
  description = "CIDRs for private database subnets"
  type        = list(string)
}

variable "eks_cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "eks_kubernetes_version" {
  description = "Kubernetes version"
  type        = string
}


variable "ecr_repository_name" {
  description = "ECR repository name for Sunco application"
  type        = string
}


variable "db_identifier" {
  type = string
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type      = string
  sensitive = true
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "db_instance_class" {
  type = string
}

variable "db_allocated_storage" {
  type = number
}

variable "db_engine_version" {
  type = string
}

variable "s3_bucket_name" {
  type = string
}

variable "environment" {
  type = string
}


variable "project_name" {
  type = string
}
