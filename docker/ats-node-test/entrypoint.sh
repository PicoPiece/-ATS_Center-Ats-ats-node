#!/bin/bash
# ATS Node Test Execution Entrypoint
# This script orchestrates the entire test execution:
# 1. Load manifest
# 2. Flash firmware
# 3. Run tests
# 4. Write results

set -e

MANIFEST_PATH="${MANIFEST_PATH:-/workspace/ats-manifest.yaml}"
RESULTS_DIR="${RESULTS_DIR:-/workspace/results}"

echo "🚀 [ATS Node] Starting test execution"
echo "📋 Manifest: ${MANIFEST_PATH}"
echo "📊 Results: ${RESULTS_DIR}"

# Debug: Show container environment
echo "🔍 Container debug info:"
echo "   User: $(whoami)"
echo "   UID: $(id -u)"
echo "   GID: $(id -g)"
echo "   Working directory: $(pwd)"
echo "   Workspace contents:"
ls -lah /workspace/ 2>&1 | head -20 || true
echo ""

# Validate manifest exists
if [ ! -f "$MANIFEST_PATH" ]; then
    echo "❌ Manifest not found: ${MANIFEST_PATH}"
    echo ""
    echo "🔍 Debugging:"
    echo "   Checking if path exists:"
    ls -lah "$MANIFEST_PATH" 2>&1 || echo "   Path does not exist"
    echo ""
    echo "   Checking workspace directory:"
    ls -lah /workspace/ 2>&1 || echo "   /workspace does not exist"
    echo ""
    echo "   Checking if file exists with different case:"
    find /workspace -iname "*manifest*" 2>&1 || echo "   No manifest files found"
    exit 1
fi

echo "✅ Manifest found and accessible"

# Create results directory
mkdir -p "$RESULTS_DIR"

# Execute test orchestration
python3 -m ats_node_test.executor \
    --manifest "$MANIFEST_PATH" \
    --results-dir "$RESULTS_DIR" \
    --workspace /workspace

EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ [ATS Node] Test execution completed successfully"
else
    echo "❌ [ATS Node] Test execution failed (exit code: ${EXIT_CODE})"
fi

exit $EXIT_CODE

