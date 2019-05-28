resource "aws_iam_role" "bucket_role" {
  count = "${length(var.bucket_name)}"
  name  = "${element(var.bucket_name, count.index)}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "iam_policy" {
  count       = "${length(var.bucket_name)}"
  name        = "${element(var.bucket_name, count.index)}"
  description = "A bucket policy"

  policy = <<POLICY
{
  "Id": "Policy1516358421104",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1516358420000",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": ["arn:aws:s3:::${element(var.bucket_name, count.index)}",
        "arn:aws:s3:::${element(var.bucket_name, count.index)}/*"]
    }
  ]
}
POLICY
}

resource "aws_iam_policy_attachment" "test-attach" {
  count      = "${length(var.bucket_name)}"
  name       = "${element(var.bucket_name, count.index)}-attachment"
  roles      = ["${element(aws_iam_role.bucket_role.*.name, count.index)}"]
  policy_arn = "${element(aws_iam_policy.iam_policy.*.arn, count.index)}"
}
