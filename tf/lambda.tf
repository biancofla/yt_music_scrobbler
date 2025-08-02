resource "aws_lambda_function" "lambda_scrobbler" {
  function_name    = local.lambda_scrobbler_function_name
  filename         = data.archive_file.lambda_scrobbler_zip.output_path
  role             = aws_iam_role.lambda_scrobbler_role.arn
  handler          = "handler.lambda_handler"
  source_code_hash = data.archive_file.lambda_scrobbler_zip.output_base64sha256
  runtime          = "python3.11"
  memory_size      = 128
  timeout          = 60
  layers           = [aws_lambda_layer_version.lambda_scrobbler_dependencies.arn]

  environment {
    variables = {
      SSM_PREFIX = "/${var.project_name}"
    }
  }

  depends_on = [
    aws_iam_role_policy.lambda_scrobbler_policy,
    aws_cloudwatch_log_group.lambda_scrobbler_log_group,
  ]
}

resource "aws_cloudwatch_log_group" "lambda_scrobbler_log_group" {
  name              = local.lambda_scrobbler_log_group_name
  retention_in_days = 14
}

data "archive_file" "lambda_scrobbler_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda/handler.py"
  output_path = "${path.module}/lambda/lambda_function.zip"
}
