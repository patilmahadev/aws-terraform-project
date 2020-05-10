output "s3-bucket" {
  value = aws_s3_bucket.remotex-s3-bucket.bucket
}

output "elb-dns" {
  value = aws_elb.remotex-elb.dns_name
}

output "website" {
  value = aws_route53_record.remotex-elb-record.name
}

output "instance-ips" {
  value = aws_instance.remotex-web-instance.*.public_ip
}
