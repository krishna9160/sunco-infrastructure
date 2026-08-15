resource "aws_db_subnet_group" "sunco" {
  name       = "${var.db_identifier}-subnet-group"
  subnet_ids = var.db_subnet_ids

  tags = {
    Name = "${var.db_identifier}-subnet-group"
  }
}

resource "aws_db_instance" "sunco" {
  identifier = var.db_identifier

  engine         = "mysql"
  engine_version = var.engine_version

  instance_class = var.db_instance_class

  allocated_storage = var.allocated_storage
  storage_type      = "gp3"
  storage_encrypted = true

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.sunco.name
  vpc_security_group_ids = [var.db_security_group_id]

  publicly_accessible = false
  multi_az            = false

  backup_retention_period = 1

  deletion_protection      = false
  skip_final_snapshot      = true
  delete_automated_backups = true

  auto_minor_version_upgrade = true

  tags = {
    Name = var.db_identifier
  }
}
