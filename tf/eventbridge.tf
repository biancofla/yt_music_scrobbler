resource "aws_cloudwatch_event_rule" "lambda_scrobbler_trigger" {
  name                = local.lambda_scrobbler_trigger_name
  description         = "Trigger Lambda function daily, at 23:50 UTC."
  schedule_expression = "cron(50 23 * * ? *)"
  state               = "ENABLED"
}

resource "aws_cloudwatch_event_target" "lambda_scrobbler_target" {
  rule      = aws_cloudwatch_event_rule.lambda_scrobbler_trigger.name
  target_id = "LambdaTarget"
  arn       = aws_lambda_function.lambda_scrobbler.arn
}

resource "aws_lambda_permission" "lambda_scrobbler_eventbridge_permission" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_scrobbler.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda_scrobbler_trigger.arn
}
