# ATS Node Test Container

> **Docker container for ATS node test execution - Hardware interaction and test orchestration**

This container is the "execution brain" that handles all hardware interaction (flashing, USB detection, GPIO access) and orchestrates test execution.

---

## Quick Start

### Using Pre-built Image (Recommended)

The image is available on GitHub Container Registry:

```bash
docker pull ghcr.io/picopiece/ats-node-test:latest
```

Or use in Jenkins pipeline:
```groovy
ATS_NODE_TEST_IMAGE = 'ghcr.io/picopiece/ats-node-test:latest'
IMAGE_SOURCE = 'registry'
```

### Building Locally

```bash
cd docker/ats-node-test
docker build -t ats-node-test:latest .
```

### Building and Pushing to Registry

```bash
cd docker/ats-node-test
./build-and-push.sh ghcr.io PicoPiece/ats-node-test latest
```

---

## What This Container Does

1. **Loads manifest** (`ats-manifest.yaml` v1) from `/workspace/ats-manifest.yaml`
2. **Flashes firmware** to target device (ESP32 via `esptool.py`)
3. **Invokes test runner** (`ats-test-esp32-demo`)
4. **Collects and writes results** in standardized format to `/workspace/results/`

---

## Usage

### Environment Variables

- `MANIFEST_PATH`: Path to `ats-manifest.yaml` (default: `/workspace/ats-manifest.yaml`)
- `RESULTS_DIR`: Directory for test results (default: `/workspace/results`)

### Volume Mounts

The container needs access to hardware:

```bash
docker run --rm --privileged \
  -v /dev:/dev \
  -v /sys/class/gpio:/sys/class/gpio:ro \
  -v /dev/gpiomem:/dev/gpiomem \
  -v $(pwd):/workspace \
  -e MANIFEST_PATH=/workspace/ats-manifest.yaml \
  -e RESULTS_DIR=/workspace/results \
  ats-node-test:latest
```

### Expected Workspace Structure

```
/workspace/
├── ats-manifest.yaml          # Required: Build manifest
├── firmware-esp32.bin         # Required: Firmware binary
├── ats-test-esp32-demo/        # Required: Test framework
│   └── agent/
│       └── run_tests.sh
└── results/                    # Output: Test results
    ├── ats-summary.json
    ├── junit.xml
    ├── serial.log
    └── meta.yaml
```

---

## Result Output

The container writes standardized test results to `/workspace/results/`:

- **`ats-summary.json`**: Human-readable test summary
- **`junit.xml`**: CI-consumable test report
- **`serial.log`**: UART output from device
- **`meta.yaml`**: Execution metadata

See [Test Output Contract v1](../../../ats-platform-docs/architecture/test-output-contract-v1.md) for details.

---

## Exit Codes

- **`0`**: All tests passed
- **`1`**: One or more tests failed
- **`2`**: Execution error (manifest not found, hardware unavailable)

---

## Building for Different Architectures

### ARM64 (Raspberry Pi)

```bash
docker buildx build --platform linux/arm64 -t ats-node-test:latest .
```

### AMD64 (Xeon Server)

```bash
docker buildx build --platform linux/amd64 -t ats-node-test:latest .
```

### Multi-arch

```bash
docker buildx build --platform linux/amd64,linux/arm64 -t ghcr.io/picopiece/ats-node-test:latest --push .
```

---

## Performance Optimization

### Use Pre-built Image

Instead of building on every test run, use a pre-built image from registry:

1. **Build once and push to registry:**
   ```bash
   ./build-and-push.sh ghcr.io PicoPiece/ats-node-test latest
   ```

2. **Update Jenkins pipeline to pull:**
   ```groovy
   IMAGE_SOURCE = 'registry'
   ATS_NODE_TEST_IMAGE = 'ghcr.io/picopiece/ats-node-test:latest'
   ```

### Docker Layer Caching

The Dockerfile is optimized for layer caching:
- Base image (`python:3.11-slim`) is cached
- System packages are installed in one layer
- Python packages are installed separately
- Application code is copied last (changes most frequently)

---

## Troubleshooting

### Container can't find manifest

- Check `MANIFEST_PATH` environment variable
- Verify manifest exists in workspace
- Check volume mount: `-v $(pwd):/workspace`

### Container can't access hardware

- Ensure `--privileged` flag is used
- Check volume mounts: `/dev`, `/sys/class/gpio`
- Verify permissions on host

### Test runner not found

- Ensure `ats-test-esp32-demo` is checked out in workspace
- Check path: `/workspace/ats-test-esp32-demo/agent/run_tests.sh`

---

## Related Documentation

- [ATS Manifest Specification v1](../../../ats-platform-docs/architecture/ats-manifest-spec-v1.md)
- [Test Output Contract v1](../../../ats-platform-docs/architecture/test-output-contract-v1.md)
- [ATS Node README](../../README.md)

---

## Author

**Hai Dang Son**  
Senior Embedded / Embedded Linux / IoT Engineer
