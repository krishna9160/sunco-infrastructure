variable "vpc_cidr" {
  description = "cidr range for suncoo"
  type        = string
}

variable "availability_zones" {
  description = "vpc availability zones"
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


