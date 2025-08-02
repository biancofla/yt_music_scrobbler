output "lambda_function_arn" {
  description = "Lambda Function ARN."
  value       = aws_lambda_function.lambda_scrobbler.arn
}

output "lambda_function_name" {
  description = "Lambda Function Name."
  value       = aws_lambda_function.lambda_scrobbler.function_name
}

output "eventbridge_rule_arn" {
  description = "EventBridge Rule ARN."
  value       = aws_cloudwatch_event_rule.lambda_scrobbler_trigger.arn
}

output "eventbridge_rule_name" {
  description = "EventBridge Rule Name."
  value       = aws_cloudwatch_event_rule.lambda_scrobbler_trigger.name
}

output "iam_role_arn" {
  description = "Lambda IAM Role ARN."
  value       = aws_iam_role.lambda_scrobbler_role.arn
}
