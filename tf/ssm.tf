resource "aws_ssm_parameter" "google_client_id" {
  name  = "/${var.project_name}/google_client_id"
  type  = "SecureString"
  value = var.google_client_id

  tags = {
    Project = var.project_name
  }
}

resource "aws_ssm_parameter" "google_client_secret" {
  name  = "/${var.project_name}/google_client_secret"
  type  = "SecureString"
  value = var.google_client_secret

  tags = {
    Project = var.project_name
  }
}

resource "aws_ssm_parameter" "google_oauth_file" {
  name  = "/${var.project_name}/google_oauth_file"
  type  = "SecureString"
  value = var.google_oauth_file

  tags = {
    Project = var.project_name
  }
}

resource "aws_ssm_parameter" "lastfm_api_key" {
  name  = "/${var.project_name}/lastfm_api_key"
  type  = "SecureString"
  value = var.lastfm_api_key

  tags = {
    Project = var.project_name
  }
}

resource "aws_ssm_parameter" "lastfm_shared_secret" {
  name  = "/${var.project_name}/lastfm_shared_secret"
  type  = "SecureString"
  value = var.lastfm_shared_secret

  tags = {
    Project = var.project_name
  }
}

resource "aws_ssm_parameter" "lastfm_username" {
  name  = "/${var.project_name}/lastfm_username"
  type  = "SecureString"
  value = var.lastfm_username

  tags = {
    Project = var.project_name
  }
}

resource "aws_ssm_parameter" "lastfm_password_hash" {
  name  = "/${var.project_name}/lastfm_password_hash"
  type  = "SecureString"
  value = var.lastfm_password_hash

  tags = {
    Project = var.project_name
  }
}
