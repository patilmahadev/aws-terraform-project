resource "aws_launch_configuration" "remotex-lc" {
  name                 = "remotex-lc"
  image_id             = lookup(var.ami, var.region)
  instance_type        = var.instance-type
  key_name             = aws_key_pair.remotex-key.id
  security_groups      = [aws_security_group.remotex-sg-ec2.id]
  iam_instance_profile = aws_iam_instance_profile.remotex-ec2-role.name
  user_data            = data.template_file.remotex-userdata.rendered
}

resource "aws_autoscaling_group" "remotex-asg" {
  depends_on                = [aws_efs_mount_target.remotex-efs-mt]
  name                      = "remotex-asg"
  max_size                  = 3
  min_size                  = 1
  desired_capacity          = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  force_delete              = true
  launch_configuration      = aws_launch_configuration.remotex-lc.name
  vpc_zone_identifier       = [aws_subnet.remotex-pub-sub.id]
  load_balancers            = [aws_elb.remotex-elb.name]
  termination_policies      = ["OldestInstance", "OldestLaunchConfiguration"]

  tags = [
    {
      key                 = "Name"
      value               = "remotex-asg-instance"
      propagate_at_launch = true
    }
  ]
}
