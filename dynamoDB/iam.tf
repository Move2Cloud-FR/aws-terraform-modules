// dynamodb table Read Policy
data "aws_iam_policy_document" "readpolicy" {
  statement {
    actions = [
      "dynamodb:DescribeTable",
      "dynamodb:GetItem",
      "dynamodb:GetRecords",
      "dynamodb:ListTables",
      "dynamodb:Query",
      "dynamodb:Scan",
    ]

    resources = ["arn:aws:dynamodb:${var.AWS_REGION}:${data.aws_caller_identity.current.account_id}:table/${var.DB_TABLE}"]

    effect = "Allow"
  }
}

resource "aws_iam_policy" "readpolicy" {
  name   = "${var.DB_TABLE}-DynamoDb-Read-Policy"
  policy = data.aws_iam_policy_document.readpolicy.json
}

// dynamodb table Write Policy
data "aws_iam_policy_document" "writepolicy" {
  statement {
    actions = [
      "dynamodb:DeleteItem",
      "dynamodb:DescribeTable",
      "dynamodb:GetItem",
      "dynamodb:GetRecords",
      "dynamodb:ListTables",
      "dynamodb:PutItem",
      "dynamodb:Query",
      "dynamodb:Scan",
      "dynamodb:UpdateItem",
      "dynamodb:UpdateTable",
    ]

    resources = ["arn:aws:dynamodb:${var.AWS_REGION}:${data.aws_caller_identity.current.account_id}:table/${var.DB_TABLE}"]

    effect = "Allow"
  }
}

resource "aws_iam_policy" "writepolicy" {
  name   = "${var.DB_TABLE}-DynamoDb-Write-Policy"
  policy = data.aws_iam_policy_document.writepolicy.json
}