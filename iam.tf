resource "aws_iam_role_policy" "remotex-ec2-role-policy" {
  name = "remotex-ec2-role-policy"
  role = aws_iam_role.remotex-ec2-role.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "S3ReadOnlyAccess",
      "Effect": "Allow",
      "Action": [
        "s3:GetAccessPoint",
        "s3:PutAccountPublicAccessBlock",
        "s3:GetAccountPublicAccessBlock",
        "s3:ListAllMyBuckets",
        "s3:ListAccessPoints",
        "s3:ListJobs",
        "s3:CreateJob",
        "s3:HeadBucket"
      ],
      "Resource": "*"
    },
    {
      "Sid": "S3FullAccess",
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": [
        "${aws_s3_bucket.remotex-s3-bucket.arn}",
        "${aws_s3_bucket.remotex-s3-bucket.arn}/*"
      ]
    }
  ]
}
POLICY
}

resource "aws_iam_role" "remotex-ec2-role" {
  name = "remotex-ec2-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "remotex-role-policy-attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
  role       = aws_iam_role.remotex-ec2-role.name
}

resource "aws_iam_instance_profile" "remotex-ec2-role" {
  name = "remotex-ec2-role"
  role = aws_iam_role.remotex-ec2-role.name
}