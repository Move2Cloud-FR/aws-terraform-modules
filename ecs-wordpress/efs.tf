# EFS file system
resource "aws_efs_file_system" "EFS" {
  performance_mode = "generalPurpose"
  throughput_mode = "bursting"
  encrypted = true

  tags = {
    Name = "${var.APP_NAME}-${var.ENV_PREFIX}-efs"
    Application = "${var.APP_NAME}"
    Environment = "${var.ENV_PREFIX}"
  }
}

# EFS mount targets security group
resource "aws_security_group" "EFS_MT_SG" {
  name        = "${var.APP_NAME}-${var.ENV_PREFIX}-efs-sg"
  vpc_id      = "${var.VPC_ID}"
  description = "Security group for ${var.APP_NAME}-${var.ENV_PREFIX}-efs"

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "TCP"
    security_groups = ["${aws_security_group.ECS_SERVICE_SG.id}"]
  }
    
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.APP_NAME}-${var.ENV_PREFIX}-efs-sg"
    Application = "${var.APP_NAME}"
    Environment = "${var.ENV_PREFIX}"
  }
}

# EFS mount targets for subnet_ids
resource "aws_efs_mount_target" "EFS_MT" {
  count           = length(var.PRIVATE_APP_SUBNETS_IDS)
  file_system_id  = aws_efs_file_system.EFS.id
  subnet_id       = var.PRIVATE_APP_SUBNETS_IDS[count.index]
  security_groups = [aws_security_group.EFS_MT_SG.id]
}

# EFS access point
resource "aws_efs_access_point" "EFS_AP" {
  file_system_id = aws_efs_file_system.EFS.id
  posix_user {
    gid   = "1000"
    uid   = "1000"
  }

  root_directory {
    creation_info {
      owner_gid   = "1000"
      owner_uid   = "1000"
      permissions = "0777"
    }
    path = "/bitnami"
  }
}