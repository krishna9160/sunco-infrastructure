module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones

  public_subnet_cidrs = var.public_subnet_cidrs
  app_subnet_cidrs    = var.app_subnet_cidrs
  db_subnet_cidrs     = var.db_subnet_cidrs
}

module "eks" {
  source = "./modules/eks"

  cluster_name       = var.eks_cluster_name
  kubernetes_version = var.eks_kubernetes_version

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.app_subnet_ids

}

data "aws_security_group" "eks_actual_node_sg" {
  id = "sg-014b447e64306cd74"
}

resource "aws_vpc_security_group_ingress_rule" "rds_from_eks" {
  security_group_id            = module.vpc.db_security_group_id
  referenced_security_group_id = data.aws_security_group.eks_actual_node_sg.id

  from_port   = 3306
  to_port     = 3306
  ip_protocol = "tcp"

  description = "Allow MySQL from actual EKS worker node SG"
}


resource "aws_vpc_security_group_ingress_rule" "alb_to_eks" {
  security_group_id            = module.eks.node_security_group_id
  referenced_security_group_id = module.vpc.alb_security_group_id

  from_port   = 8080
  to_port     = 8080
  ip_protocol = "tcp"

  description = "Allow application traffic from ALB"
}


module "ecr" {
  source = "./modules/ecr"

  repository_name = var.ecr_repository_name
}


module "rds" {
  source = "./modules/rds"

  db_identifier = var.db_identifier
  db_name       = var.db_name
  db_username   = var.db_username
  db_password   = var.db_password

  db_instance_class = var.db_instance_class
  allocated_storage = var.db_allocated_storage
  engine_version    = var.db_engine_version

  db_subnet_ids        = module.vpc.db_subnet_ids
  db_security_group_id = module.vpc.db_security_group_id
}


module "s3" {
  source = "./modules/s3"

  bucket_name = var.s3_bucket_name
  environment = var.environment

  project_name        = var.project_name
  eks_oidc_issuer_url = module.eks.oidc_issuer_url
}

