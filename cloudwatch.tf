resource "aws_cloudwatch_event_rule" "remotex-ec2-state-change-event-rule" {
  name          = "remotex-ec2-state-change-event-rule"

  event_pattern = <<PATTERN
{
  "source": [
    "aws.ec2"
  ],
  "detail-type": [
    "EC2 Instance State-change Notification"
  ],
  "detail": {
    "state": [
      "stopped"
    ]
  }
}
PATTERN
}

resource "aws_cloudwatch_event_target" "remotex-cw-event-target" {
  arn  = aws_sns_topic.remotex-sns-topic.arn
  rule = aws_cloudwatch_event_rule.remotex-ec2-state-change-event-rule.name
}