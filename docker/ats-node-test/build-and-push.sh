#!/bin/bash
# Build and push ats-node-test Docker image to registry
# Usage: ./build-and-push.sh [registry] [tag]

set -e

REGISTRY="${1:-ghcr.io}"
IMAGE_NAME="${2:-PicoPiece/ats-node-test}"
TAG="${3:-latest}"
FULL_IMAGE="${REGISTRY}/${IMAGE_NAME}:${TAG}"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "🐳 Building and pushing ATS Node Test image"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Registry: ${REGISTRY}"
echo "Image: ${IMAGE_NAME}"
echo "Tag: ${TAG}"
echo "Full: ${FULL_IMAGE}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Build image
echo "🔨 Building Docker image..."
cd "$SCRIPT_DIR"
docker build -t "${FULL_IMAGE}" .

# Tag as latest locally too
docker tag "${FULL_IMAGE}" "ats-node-test:latest"

echo ""
echo "✅ Image built: ${FULL_IMAGE}"
echo ""

# Ask if user wants to push
read -p "Push to registry? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "📤 Pushing to registry..."
    docker push "${FULL_IMAGE}"
    echo "✅ Image pushed: ${FULL_IMAGE}"
    echo ""
    echo "📝 To use this image, update Jenkinsfile.test:"
    echo "   ATS_NODE_TEST_IMAGE = '${FULL_IMAGE}'"
else
    echo "⏭️  Skipped push. Image available locally as: ${FULL_IMAGE}"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Done"

