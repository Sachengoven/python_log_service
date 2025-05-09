# Get the current AWS caller identity
data "aws_caller_identity" "current" {}

# Create an IAM role for the Lambda functions to access DynamoDB
resource "aws_iam_role" "lambda_role" {
  name = "lambda_log_service_role_${random_string.suffix.result}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Create IAM policy for Lambda function to access DynamoDB and KMS
resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda_log_service_policy_${random_string.suffix.result}"
  description = "IAM policy for Lambda function to access DynamoDB and KMS"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:PutItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ],
        Effect = "Allow"
        Resource = [
          aws_dynamodb_table.log_table.arn,
          "${aws_dynamodb_table.log_table.arn}/index/*"
        ]
      },
      {
        Action = [
          "kms:Decrypt",
          "kms:Encrypt",
          "kms:GenerateDataKey"
        ],
        Effect = "Allow"
        Resource = [
          aws_kms_key.dynamodb_kms_key.arn
        ]
      },
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect = "Allow"
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}