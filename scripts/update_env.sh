#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR=$(cd -- "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

MODELS_DIR="${HOME}/sd-models"
OUTPUTS_DIR="${HOME}/Pictures"

cat <<EOF > "${ROOT_DIR}/.env"
# Absolute host paths for docker-compose volume mounts.
SD_MODELS_DIR=${MODELS_DIR}
SD_OUTPUTS_DIR=${OUTPUTS_DIR}
EOF

echo ".env updated with:"
cat "${ROOT_DIR}/.env"
