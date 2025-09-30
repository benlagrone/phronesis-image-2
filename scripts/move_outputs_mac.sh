#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT=$(cd -- "${SCRIPT_DIR}/.." && pwd)

SRC_DIR="${REPO_ROOT}/stable-diffusion-webui/outputs"
DEST_PARENT="${HOME}/Pictures"
DEST_DIR="${DEST_PARENT}/$(basename "${SRC_DIR}")"

echo "Source outputs directory: ${SRC_DIR}"
echo "Destination outputs directory: ${DEST_DIR}"

if [[ -L "${SRC_DIR}" ]]; then
  target=$(readlink "${SRC_DIR}")
  echo "Outputs directory already symlinked to ${target}."
  if [[ "${CREATE_SYMLINK:-0}" != "1" ]]; then
    rm -f "${SRC_DIR}"
    echo "Removed existing symlink."
  fi
  exit 0
fi

if [[ ! -d "${SRC_DIR}" ]]; then
  echo "Outputs directory not found; nothing to move."
  exit 0
fi

mkdir -p "${DEST_PARENT}"

if [[ ! -d "${DEST_DIR}" ]]; then
  echo "Moving entire outputs directory to ${DEST_DIR}"
  mv "${SRC_DIR}" "${DEST_DIR}"
else
  echo "Destination already exists; moving individual items."
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

  rm -rf "${SRC_DIR}"
fi

if [[ "${CREATE_SYMLINK:-0}" == "1" ]]; then
  ln -s "${DEST_DIR}" "${SRC_DIR}"
  echo "Created symlink ${SRC_DIR} -> ${DEST_DIR}"
else
  echo "Outputs moved to ${DEST_DIR}. Original directory removed."
fi
