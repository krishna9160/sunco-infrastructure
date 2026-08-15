resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "sunco-vpc"
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name        = "sunco-public-${var.availability_zones[count.index]}"
    Tier        = "public"
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}


resource "aws_subnet" "app" {
  count = length(var.app_subnet_cidrs)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.app_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name        = "sunco-app-${var.availability_zones[count.index]}"
    Tier        = "private-app"
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}


resource "aws_subnet" "db" {
  count = length(var.db_subnet_cidrs)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.db_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name        = "sunco-db-${var.availability_zones[count.index]}"
    Tier        = "private-db"
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}


resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "sunco-igw"
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "sunco-public-rt"
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}


resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidrs)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "app" {
  count = length(var.app_subnet_cidrs)

  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "sunco-app-rt-${var.availability_zones[count.index]}"
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}


resource "aws_route_table_association" "app" {
  count = length(var.app_subnet_cidrs)

  subnet_id      = aws_subnet.app[count.index].id
  route_table_id = aws_route_table.app[count.index].id
}

resource "aws_route_table" "db" {
  count = length(var.db_subnet_cidrs)

  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "sunco-db-rt-${var.availability_zones[count.index]}"
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}


resource "aws_route_table_association" "db" {
  count = length(var.db_subnet_cidrs)

  subnet_id      = aws_subnet.db[count.index].id
  route_table_id = aws_route_table.db[count.index].id
}


resource "aws_eip" "nat" {
  count = length(var.availability_zones)

  domain = "vpc"

  tags = {
    Name        = "sunco-nat-eip-${var.availability_zones[count.index]}"
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}


resource "aws_nat_gateway" "main" {
  count = length(var.availability_zones)

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name        = "sunco-nat-${var.availability_zones[count.index]}"
    Environment = "prod"
    ManagedBy   = "Terraform"
  }

  depends_on = [
    aws_internet_gateway.main
  ]
}


resource "aws_route" "app_nat" {
  count = length(var.app_subnet_cidrs)

  route_table_id         = aws_route_table.app[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main[count.index].id
}

resource "aws_security_group" "alb" {
  name        = "sunco-alb-sg"
  description = "Security group for Sunco Application Load Balancer"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow HTTPS from internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "sunco-alb-sg"
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}


resource "aws_security_group" "db" {
  name        = "sunco-db-sg"
  description = "Security group for Sunco database"
  vpc_id      = aws_vpc.main.id

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "sunco-db-sg"
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}


