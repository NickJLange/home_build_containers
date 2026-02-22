#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
OUTPUT_DIR="${PROJECT_DIR}/output"

LOCAL_PREFIX="${HOME}/.local"

usage() {
    echo "Usage: $0 <artifact> [destination]"
    echo ""
    echo "Install compiled artifacts from output/ to ~/.local"
    echo ""
    echo "Examples:"
    echo "  $0 myapp              # Install to ~/.local/bin/myapp"
    echo "  $0 myapp bin          # Install to ~/.local/bin/myapp"
    echo "  $0 libfoo.so lib      # Install to ~/.local/lib/libfoo.so"
    echo "  $0 libfoo.a lib       # Install to ~/.local/lib/libfoo.a"
    echo "  $0 foo.h include      # Install to ~/.local/include/foo.h"
    exit 1
}

[[ $# -lt 1 ]] && usage

ARTIFACT="$1"
DEST_TYPE="${2:-bin}"

SOURCE="${OUTPUT_DIR}/${ARTIFACT}"
if [[ ! -e "$SOURCE" ]]; then
    echo "Error: Artifact '$SOURCE' not found"
    echo "Available artifacts in output/:"
    ls -la "$OUTPUT_DIR" 2>/dev/null || echo "  (empty)"
    exit 1
fi

DEST_DIR="${LOCAL_PREFIX}/${DEST_TYPE}"
mkdir -p "$DEST_DIR"

cp -v "$SOURCE" "$DEST_DIR/"

if [[ "$DEST_TYPE" == "bin" ]]; then
    chmod +x "${DEST_DIR}/$(basename "$ARTIFACT")"
fi

echo "Installed: ${DEST_DIR}/$(basename "$ARTIFACT")"
