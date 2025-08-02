# YouTube Music Scrobbler

Automatically scrobble your YouTube Music listening history.

## Requirements

- Python 3.11+
- [uv](https://github.com/astral-sh/uv) (Python package manager)
- Terraform >= 1.0
- AWS CLI configured
- Google account with YouTube Music access.

## Initial Setup

### Google OAuth Credentials (Client ID and Secret)

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project, or select an existing one
3. Enable YouTube Data API v3
4. Create OAuth 2.0 credentials (type: TV and Limited Input Device)
5. Download the credentials JSON file containing `client_id` and `client_secret`

### Google OAuth Token

To get the initial token, use `ytmusicapi`:

```bash
# Install ytmusicapi.
uv pip install ytmusicapi

# Generate OAuth token.
ytmusicapi oauth
```

Follow the instructions to authenticate. The generated `oauth.json` file contains the token to use in the application.

## Deployment

### 1. Terraform Configuration

Create a `terraform.tfvars` file in the `tf/` directory with the environment variables defined in the example file.

### 2. Deploy Infrastructure

```bash
cd tf

# Initialize Terraform.
terraform init

# Review Deployment Plan.
terraform plan

# Apply Changes.
terraform apply
```

### 3. Verify Deployment

```bash
# Manual Lambda test.
aws lambda invoke \
  --function-name yt_music_scrobbler-function \
  --region eu-central-1 \
  output.json

# Check logs.
aws logs tail /aws/lambda/yt_music_scrobbler-function
```

## Development

### Local Setup

```bash
# Install dependencies.
uv pip install -e .
```

### Local Testing

```bash
# Run handler locally
python tf/lambda/handler.py
```