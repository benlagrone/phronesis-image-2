#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT=$(cd -- "${SCRIPT_DIR}/.." && pwd)

SRC_DIR="${REPO_ROOT}/stable-diffusion-webui/models"
DEST_DIR="${HOME}/sd-models"

echo "Source directory: ${SRC_DIR}"
echo "Destination directory: ${DEST_DIR}"

if [[ ! -d "${SRC_DIR}" ]]; then
  echo "Source models directory not found." >&2
  exit 1
fi

mkdir -p "${DEST_DIR}"

shopt -s nullglob dotglob
items=("${SRC_DIR}"/*)
if (( ${#items[@]} == 0 )); then
  echo "Nothing to move from ${SRC_DIR}."
else
  for path in "${items[@]}"; do
    name=$(basename "${path}")
    if [[ -e "${DEST_DIR}/${name}" ]]; then
      echo "Destination already contains ${name}; removing the project copy."
      rm -rf "${path}"
      continue
    fi
    echo "Moving ${name} to ${DEST_DIR}"
    mv "${path}" "${DEST_DIR}/"
  done
fi
shopt -u nullglob dotglob

if [[ -d "${SRC_DIR}" && ! -L "${SRC_DIR}" ]]; then
  if rmdir "${SRC_DIR}" 2>/dev/null; then
    ln -s "${DEST_DIR}" "${SRC_DIR}"
    echo "Created symlink ${SRC_DIR} -> ${DEST_DIR}"
  else
    echo "Could not remove ${SRC_DIR}; leaving contents as-is." >&2
  fi
fi

echo "Model artifacts are now stored in ${DEST_DIR}."
