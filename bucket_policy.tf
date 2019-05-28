resource "aws_s3_bucket" "bucket_creation" {
  count         = "${length(var.bucket_name)}"
  bucket        = "${element(var.bucket_name, count.index)}"
  acl           = "private"
  force_destroy = "true"
}

resource "aws_s3_bucket_policy" "policy_creation" {
  count  = "${length(var.bucket_name)}"
  bucket = "${element(aws_s3_bucket.bucket_creation.*.id,count.index)}"

  policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "Limited Permission",
            "Effect": "Allow",
            "Principal": {
                "AWS": "${element(aws_iam_role.bucket_role.*.arn, count.index)}"
            },
            "Action": [
              "s3:GetBucketLocation",
              "s3:ListBucket",
              "s3:PutObject",
              "s3:GetObject",
              "s3:DeleteObject"
            ],

            "Resource": [
                "arn:aws:s3:::${element(var.bucket_name, count.index)}",
                "arn:aws:s3:::${element(var.bucket_name, count.index)}/*"
            ]
        }
    ]
}
EOF
}
