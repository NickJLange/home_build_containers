#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

IMAGE_NAME="${BUILD_CONTAINER_IMAGE:-build-container}"
IMAGE_TAG="${BUILD_CONTAINER_TAG:-latest}"
OUTPUT_DIR="${PROJECT_DIR}/output"

PROJECT_PATH="${1:-$(pwd)}"

if [[ ! -d "$PROJECT_PATH" ]]; then
    echo "Error: Directory '$PROJECT_PATH' does not exist"
    echo "Usage: $0 [/path/to/project]"
    exit 1
fi

PROJECT_PATH="$(cd "$PROJECT_PATH" && pwd)"

echo "Starting build container..."
echo "  Project: $PROJECT_PATH -> /workspace"
echo "  Output:  $OUTPUT_DIR -> /output"

exec podman run -it --rm \
    --userns=keep-id \
    -v "${PROJECT_PATH}:/workspace:Z" \
    -v "${OUTPUT_DIR}:/output:Z" \
    -e "HOME=/workspace" \
    "${IMAGE_NAME}:${IMAGE_TAG}"
