#!/usr/bin/env bash

set -euo pipefail

# Ensure bind-mounted directories exist so the WebUI can write to them.
mkdir -p /data/models
mkdir -p /data/pictures

# Seed the mounted models directory with defaults bundled in the image if it's empty.
SOURCE_MODELS_DIR="/app/stable-diffusion-webui/models"
TARGET_MODELS_DIR="/data/models"

if [[ -d "${SOURCE_MODELS_DIR}" ]]; then
  if [[ ! -d "${TARGET_MODELS_DIR}" ]]; then
    mkdir -p "${TARGET_MODELS_DIR}"
  fi

  if [[ -z "$(ls -A "${TARGET_MODELS_DIR}" 2>/dev/null)" ]]; then
    echo "Populating model directory at ${TARGET_MODELS_DIR}"
    cp -a "${SOURCE_MODELS_DIR}/." "${TARGET_MODELS_DIR}/"
  fi
fi

# Ensure the WebUI writes outputs to the mounted host directory
LEGACY_SUBDIR="/data/pictures/outputs"
if [[ -d "${LEGACY_SUBDIR}" ]]; then
  echo "Flattening legacy outputs directory at ${LEGACY_SUBDIR}"
  shopt -s dotglob
  mv "${LEGACY_SUBDIR}"/* /data/pictures/ 2>/dev/null || true
  shopt -u dotglob
  rmdir "${LEGACY_SUBDIR}" 2>/dev/null || true
fi

if [[ -d /app/stable-diffusion-webui/outputs && ! -L /app/stable-diffusion-webui/outputs ]]; then
  rm -rf /app/stable-diffusion-webui/outputs
fi
ln -sfn /data/pictures /app/stable-diffusion-webui/outputs

cd /app/stable-diffusion-webui

exec "$@"
