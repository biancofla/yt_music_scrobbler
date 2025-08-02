variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "eu-central-1"
}

variable "project_name" {
  description = "Project Name"
  type        = string
  default     = "yt-music-scrobbler"
}

variable "google_client_id" {
  description = "YouTube Music API Client ID"
  type        = string
  sensitive   = true
}

variable "google_client_secret" {
  description = "YouTube Music API Client Secret"
  type        = string
  sensitive   = true
}

variable "google_oauth_file" {
  description = "YouTube Music API OAuth File"
  type        = string
  sensitive   = true
}

variable "lastfm_api_key" {
  description = "Last.fm API Key"
  type        = string
  sensitive   = true
}

variable "lastfm_shared_secret" {
  description = "Last.fm Shared Secret"
  type        = string
  sensitive   = true
}

variable "lastfm_username" {
  description = "Last.fm Username"
  type        = string
  sensitive   = true
}

variable "lastfm_password_hash" {
  description = "Last.fm Password Hash"
  type        = string
  sensitive   = true
}
