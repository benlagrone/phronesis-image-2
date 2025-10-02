#!/usr/bin/env bash

set -euo pipefail

# Ensure bind-mounted directories exist so the WebUI can write to them.
mkdir -p /data/models
mkdir -p /data/pictures/outputs

# Ensure the WebUI writes outputs to the mounted host directory
if [[ -d /app/stable-diffusion-webui/outputs && ! -L /app/stable-diffusion-webui/outputs ]]; then
  rm -rf /app/stable-diffusion-webui/outputs
fi
ln -sfn /data/pictures/outputs /app/stable-diffusion-webui/outputs

cd /app/stable-diffusion-webui

exec "$@"
