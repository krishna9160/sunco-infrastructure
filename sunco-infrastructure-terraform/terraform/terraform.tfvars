aws_region = "ap-southeast-1"

vpc_cidr = "10.0.0.0/16"

availability_zones = [
  "ap-southeast-1a",
  "ap-southeast-1b"
]

public_subnet_cidrs = [
  "10.0.1.0/24",
  "10.0.2.0/24"
]

app_subnet_cidrs = [
  "10.0.11.0/24",
  "10.0.12.0/24"
]

db_subnet_cidrs = [
  "10.0.21.0/24",
  "10.0.22.0/24"
]

eks_cluster_name       = "sunco-prod-eks"
eks_kubernetes_version = "1.33"

ecr_repository_name = "sunco"


db_identifier        = "sunco-mysql"
db_name              = "sunco"
db_username          = "suncoadmin"
db_password          = "Vamsi5170"
db_instance_class    = "db.t3.micro"
db_allocated_storage = 20
db_engine_version    = "8.0"

s3_bucket_name = "sunco-app-mediastoragebucket"
environment    = "dev"

project_name = "sunco"
