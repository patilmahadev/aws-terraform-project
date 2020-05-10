resource "aws_security_group" "remotex-sg-ec2" {
  name   = "remotex-sg-ec2"
  vpc_id = aws_vpc.remotex-vpc.id

  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["10.10.0.0/16"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "remotex-sg-ec2"
  }
}

resource "aws_key_pair" "remotex-key" {
  key_name   = "remotex-key"
  public_key = file("remotex-key.pub")
}

resource "aws_instance" "remotex-web-instance" {
  depends_on             = [aws_efs_mount_target.remotex-efs-mt]
  ami                    = lookup(var.ami, var.region)
  instance_type          = var.instance-type
  key_name               = aws_key_pair.remotex-key.id
  vpc_security_group_ids = [aws_security_group.remotex-sg-ec2.id]
  subnet_id              = aws_subnet.remotex-pub-sub.id
  iam_instance_profile   = aws_iam_instance_profile.remotex-ec2-role.name
  user_data              = data.template_file.remotex-userdata.rendered
  count                  = 2
  tags = {
    Name = "remotex-web-instance-${format("%02d", count.index + 1)}"
  }
}