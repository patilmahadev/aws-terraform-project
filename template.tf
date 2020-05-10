data "template_file" "remotex-userdata" {
  template = file("userdata.tpl")

  vars = {
    efs_dns_name = aws_efs_file_system.remotex-efs.dns_name
  }
}