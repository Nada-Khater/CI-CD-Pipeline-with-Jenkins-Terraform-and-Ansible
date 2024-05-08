data "archive_file" "lambda" {
  type        = "zip"
  source_file = "Python/lambda_fn.py"
  output_path = "./Python/lambdafn.zip"
}

resource "aws_lambda_function" "send_email_lambda" {
  filename      = "./Python/lambdafn.zip"
  function_name = "send_email_lambda"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_fn.lambda_handler"
  runtime       = "python3.8"
}

resource "aws_s3_bucket_notification" "state_file_change_notification" {
  bucket = "terraform-nada"

  lambda_function {
    lambda_function_arn = aws_lambda_function.send_email_lambda.arn
    events              = ["s3:ObjectCreated:*"]
  }
}

resource "aws_lambda_permission" "allow_s3_trigger" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.send_email_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::terraform-nada"
}
