locals {
  app_registry_name = "YTMusicScrobbler"

  lambda_scrobbler_function_name    = "${var.project_name}-function"
  lambda_scrobbler_log_group_name   = "/aws/lambda/${var.project_name}"
  lambda_scrobbler_assume_role_name = "${var.project_name}-lambda-role"
  lambda_scrobbler_policy_name      = "${var.project_name}-lambda-policy"
  lambda_scrobbler_trigger_name     = "${var.project_name}-trigger"
  lambda_scrobbler_layer_name       = "${var.project_name}-layer"
}
