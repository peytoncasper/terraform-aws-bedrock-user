provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = "us-east-1" 
}

resource "aws_iam_user" "user" {
  name = "user-${var.sandbox_id}"
}

resource "aws_iam_access_key" "user_key" {
  user = aws_iam_user.user.name
}

resource "aws_iam_policy" "bedrock_policy" {
  name        = "bedrock-policy-${var.sandbox_id}"
  description = "Policy to access AWS Bedrock endpoints"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "bedrock:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_user_policy_attachment" "user_bedrock_policy_attachment" {
  user       = aws_iam_user.user.name
  policy_arn = aws_iam_policy.bedrock_policy.arn
}

output "access_key" {
  value = aws_iam_access_key.user_key.id
  sensitive = true
}

output "secret_key" {
  value = aws_iam_access_key.user_key.secret
  sensitive = true
}
