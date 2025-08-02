#!/bin/bash
set -e

# Navigate to script directory.
cd "$(dirname "$0")"

# Clean previous builds.
rm -rf layer layer.zip

# Create layer directory structure.
mkdir -p layer/python

# Install dependencies.
echo "Installing production dependencies for Lambda Layer..."
uv pip install --system --target layer/python boto3 ytmusicapi pylast

echo "Lambda Layer dependencies installed successfully!"