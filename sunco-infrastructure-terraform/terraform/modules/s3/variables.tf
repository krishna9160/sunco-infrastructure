variable "bucket_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "project_name" {
  type = string
}

variable "eks_oidc_issuer_url" {
  description = "OIDC issuer URL of the EKS cluster"
  type        = string
}
