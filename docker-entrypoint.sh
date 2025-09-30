#!/usr/bin/env bash

set -euo pipefail

# Ensure bind-mounted directories exist so the WebUI can write to them.
mkdir -p /data/models
mkdir -p /data/pictures/outputs

cd /app/stable-diffusion-webui

exec "$@"
