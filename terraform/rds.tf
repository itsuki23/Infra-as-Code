# ------------------------------
#  RDS
# ------------------------------

resource "aws_db_instance" "rds" {
  identifier                 = "taskleaf-rds"
  allocated_storage          = 20
  storage_type               = "gp2"
  engine                     = "mysql"
  engine_version             = "8.0.15"
  instance_class             = "db.t2.micro"
  name                       = "taskleaf-db"
  username                   = "root"
  password                   = "password"
  parameter_group_name       = "default.mysql8.0"
  auto_minor_version_upgrade = true
  availability_zone          = "ap-northeast-1a"
  backup_retention_period    = 7
  backup_window              = "17:21-17:51"
  db_subnet_group_name       = "taskleaf_rds_subnet_group"
  deletion_protection        = false
  skip_final_snapshot        = true
}

# ------------------------------
#  DB_SubnetGroup
# ------------------------------

resource "aws_db_subnet_group" "rds" {
  name = "taskleaf_rds_subnet_group"
  description = "subnet_group_for_rds"
  subnet_ids = [
    "${aws_subnet.private_1a.id}",
    "${aws_subnet.private_1c.id}"
  ]
}

# ------------------------------
#  SecurityGroup
# ------------------------------

resource "aws_security_group" "private_rds" {
  name        = "taskleaf-ec2-sg"
  description = "Allow ssh http https"
  vpc_id      = aws_vpc.public.id

  ingress {
      from_port = 3306
      to_port = 3306
      protocol = "tcp"
      security_groups = [aws_security_group.ec2.id]
  }
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
}