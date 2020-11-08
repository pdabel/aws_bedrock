resource "aws_cloudwatch_log_group" "cw-logs" {
  name              = "/aws/lambda/${aws_lambda_function.test_lambda.function_name}"
  retention_in_days = 14
}

