env = "stage"

#bucket policy
#bucket11policy = bucket11policy.json
/*
bucket11policy = jsonencode ({
    Version = "2012-10-17"
    Statement = [
        {
            Effect = "Allow"
            Action = ["s3:GetObject","s3:ListBucket",]
            resources = "*"
        }
    ]
})*/
/*canonical_external_account = "f455e1f023c69be9edb5530be176ddbc2d633abfbaaf53e05c24f156c9b6d518"
canonical_owner_account    = "cc750c0f94fb55af4339a74c4a2ca3a77ba9cb236c9038df71c541c37266c81d"*/
/*
bucket11policy = <<POLICY
statement {
    principals {
        type        = "AWS"
        identifiers = ["arn:aws:iam::409269111861:root"]
    }

    actions = [
        "s3:GetObject",
        "s3:ListBucket",
    ]

    resources = [
        aws_s3_bucket.terra_bucket11.arn,
        "${aws_s3_bucket.terra_bucket11.arn}/*",
    ]
  }
}
POLICY
*/