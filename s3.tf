resource "aws_s3_bucket" "remotex-s3-bucket" {
  bucket_prefix = "remotex-s3-bucket-"
  region        = var.region
  acl           = "private"
  force_destroy = true
}

resource "aws_s3_bucket_notification" "remotex-notification" {
  bucket = aws_s3_bucket.remotex-s3-bucket.id

  topic {
    id        = "remotex-notification"
    events    = ["s3:ObjectCreated:*"]
    topic_arn = aws_sns_topic.remotex-sns-topic.arn
  }
}