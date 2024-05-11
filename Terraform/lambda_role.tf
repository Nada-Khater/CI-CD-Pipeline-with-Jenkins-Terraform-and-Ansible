# Define IAM role for Lambda function
resource "aws_iam_role" "lambda_role" {
  name               = "lambda_ses_role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

# Attach AmazonSESFullAccess policy to IAM role
resource "aws_iam_role_policy_attachment" "ses_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSESFullAccess"
}

# Attach AWSLambdaBasicExecutionRole policy to IAM role
resource "aws_iam_role_policy_attachment" "basic_execution_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
