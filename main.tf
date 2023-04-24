locals {
  namespace = "namespace"
  product_id = "product_id"
  name = "name"
}

resource "aws_iam_user" "user-example" {
  name          = format("%s-%s-%s-%s", local.namespace, local.product_id, local.name, "service")
  force_destroy = true
}

# Se requiere la incorporacion de una clave PGP/GPG para pgp_key
resource "aws_iam_access_key" "user-example" {
  user    = aws_iam_user.user-example.name
  pgp_key = "pgp_key"
}

resource "aws_iam_user_policy" "user-example" {
  name = format("%s-%s-%s-%s", local.namespace, local.product_id, local.name, "policy")
  user = aws_iam_user.user-example.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "lakeformation:GetDataAccess"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:Get*",
        "s3:List*",
        "s3:Describe*"
      ],
      "Resource": [
        "arn:aws:s3-object-lambda:*:*:accesspoint/*",
        "arn:aws:s3:*:*:accesspoint/*",
        "arn:aws:s3:*:*:job/*",
        "arn:aws:s3:*:*:storage-lens/*",
        "arn:aws:s3:::*dlake-raw*/*",
        "arn:aws:s3:::*dlake-raw*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource":"*"
    },
    {
        "Effect":"Allow",
        "Action":"kms:*",
        "Resource": [
        "*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "athena:StartQueryExecution",
        "athena:GetQueryResults",
        "athena:StopQueryExecution",
        "athena:BatchGetQueryExecution",
        "athena:ListQueryExecutions",
        "athena:GetQueryExecution",
        "athena:GetWorkGroup",
        "athena:ListWorkGroups",
        "athena:GetQueryResultsStream"
      ],
      "Resource": [
        "*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "glue:Get*"
      ],
      "Resource": [
        "arn:aws:glue:us-east-1:*:table/*/*",
        "arn:aws:glue:us-east-1:*:database/*",
        "arn:aws:glue:us-east-1:*:catalog"
      ]
    }
  ]
}
EOF
}