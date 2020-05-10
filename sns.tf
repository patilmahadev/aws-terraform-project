resource "aws_sns_topic" "remotex-sns-topic" {
  name         = "remotex-sns-topic"
  display_name = "remoteX SNS"

  policy = <<POLICY
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Effect": "Allow",
      "Principal": {
        "AWS":"*"
      },
      "Action": "SNS:Publish",
      "Resource": "arn:aws:sns:*:*:remotex-sns-topic",
      "Condition":{
        "ArnLike":{"aws:SourceArn":"${aws_s3_bucket.remotex-s3-bucket.arn}"}
      }
    }
  ]
}
POLICY
}