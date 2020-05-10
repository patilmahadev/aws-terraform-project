resource "aws_security_group" "remotex-sg-efs" {
  name   = "remotex-sg-efs"
  vpc_id = aws_vpc.remotex-vpc.id

  ingress {
    from_port   = 2049
    protocol    = "tcp"
    to_port     = 2049
    cidr_blocks = [aws_subnet.remotex-pub-sub.cidr_block]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "remotex-sg-efs"
  }
}

resource "aws_efs_file_system" "remotex-efs" {
  creation_token = "remotex-efs"
  tags = {
    Name = "remotex-efs"
  }
}

resource "aws_efs_mount_target" "remotex-efs-mt" {
  file_system_id  = aws_efs_file_system.remotex-efs.id
  subnet_id       = aws_subnet.remotex-pub-sub.id
  security_groups = [aws_security_group.remotex-sg-efs.id]
}