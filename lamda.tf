resource "aws_lambda_function" "start_bedrock_lambda" {
    function_name = "start_bedrock"
    s3_bucket = aws_s3_bucket.lamda-bucket.id
    s3_key = "start.zip"
    #s3_object_version = "value"
    handler = "lambda_handler"
    runtime = "python3.7"
    role = aws_iam_role.run_lamda.id

    # ... other configuration ...
    depends_on = [
        aws_iam_role_policy_attachment.lamda-role-policy,
        aws_cloudwatch_log_group.cw-logs,
    ]
}

resource "aws_lambda_function" "stop_bedrock_lambda" {
    function_name = "stop_bedrock"
    s3_bucket = aws_s3_bucket.lamda-bucket.id
    s3_key = "stop.zip"
    #s3_object_version = "value"
    handler = "lambda_handler"
    runtime = "python3.7"
    role = aws_iam_role.run_lamda.id

    # ... other configuration ...
    depends_on = [
        aws_iam_role_policy_attachment.lamda-role-policy,
        aws_cloudwatch_log_group.cw-logs,
    ]
}