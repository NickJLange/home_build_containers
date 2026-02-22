#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

IMAGE_NAME="${BUILD_CONTAINER_IMAGE:-build-container}"
IMAGE_TAG="${BUILD_CONTAINER_TAG:-latest}"

echo "Building container image: ${IMAGE_NAME}:${IMAGE_TAG}"

podman build \
    -t "${IMAGE_NAME}:${IMAGE_TAG}" \
    -f "${PROJECT_DIR}/Containerfile" \
    "${PROJECT_DIR}"

echo "Done. Run with: ./scripts/run.sh /path/to/your/project"
