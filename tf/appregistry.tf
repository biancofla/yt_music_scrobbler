provider "aws" {
  alias  = "appregistry"
  region = var.aws_region
}

resource "aws_servicecatalogappregistry_application" "yt_music_scrobbler" {
  provider    = aws.appregistry
  name        = local.app_registry_name
  description = "YouTube Music Scrobbler - Automatically scrobble YouTube Music listening history to Last.fm."
}
