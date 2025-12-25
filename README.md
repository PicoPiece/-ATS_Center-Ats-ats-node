# ATS Node

> **ATS Node Execution Brain - Hardware interaction and test orchestration**

The ATS node is the execution and observation plane of the ATS platform. It owns all hardware interaction (flashing, USB detection, GPIO control) and orchestrates test execution. It is intentionally separated from CI infrastructure to ensure deterministic hardware access, reliable test execution, and reproducible results on real devices.

---

## 📁 Repository Structure

```
ats-ats-node/
├── README.md
├── docker/
│   └── ats-node-test/          # Docker container for test execution
│       ├── Dockerfile
│       ├── entrypoint.sh
│       ├── ats_node_test/      # Python package
│       │   ├── manifest.py      # Manifest loading/validation
│       │   ├── hardware.py      # Hardware detection (USB, GPIO)
│       │   ├── flash_esp32.py   # Firmware flashing
│       │   ├── executor.py      # Test orchestration
│       │   └── results.py       # Result generation
│       └── README.md
├── agent/                       # Legacy/placeholder scripts (future)
│   ├── flash_fw.sh
│   └── run_tests.sh
└── REVIEW.md
```

---

## 🎯 Role of the ATS Node

The ATS node provides the **Execution Brain** for hardware testing:

- **Hardware access** (UART, GPIO, USB detection)
- **Firmware flashing** (via `esptool.py` for ESP32)
- **Test orchestration** (loads manifest, flashes firmware, invokes test runner)
- **Result generation** (structured output in `/results` directory)
- **Hardware abstraction** (Jenkins doesn't know about USB ports, GPIO pins)

**Key Principle:** Jenkins is "dumb" — it only runs the `ats-node-test` container. All hardware logic lives here.

---

## 🔗 Relationship to Other Repositories

- **`ats-ci-infra`**: Receives test jobs and artifacts from Jenkins
- **`ats-test-esp32-demo`**: Test execution framework that uses these tools
- **`ats-fw-esp32-demo`**: Consumes firmware artifacts for testing
- **`ats-platform-docs`**: System architecture documentation

---

## 📊 Current Implementation

**ATS Node Execution Brain (`ats-node-test` container)**

The `docker/ats-node-test/` directory contains the Docker container that is the **execution brain** for hardware testing:

1. **Loads manifest** (`ats-manifest.yaml` v1) - see [ATS Manifest Spec v1](../ats-platform-docs/architecture/ats-manifest-spec-v1.md)
2. **Flashes firmware** to target device (ESP32 via `esptool.py`)
3. **Invokes test runner** (`ats-test-esp32-demo`)
4. **Collects and writes results** in standardized format - see [Test Output Contract v1](../ats-platform-docs/architecture/test-output-contract-v1.md)

**Result Output:**
- `/results/ats-summary.json` - Human-readable summary
- `/results/junit.xml` - CI-consumable test report
- `/results/serial.log` - UART output
- `/results/meta.yaml` - Execution metadata

**Exit Codes:**
- `0` = All tests passed
- `1` = Tests failed
- `2` = Execution error (manifest not found, hardware unavailable)

## 📋 Repository Responsibilities

### ✅ What This Repository Does

- **Hardware interaction** (flashing, USB detection, GPIO access)
- **Test orchestration** (manifest loading, firmware flashing, test runner invocation)
- **Result aggregation** (collecting test results and writing standardized output)
- **Hardware abstraction** (Jenkins doesn't need to know about USB ports, GPIO pins)

### ❌ What This Repository Does NOT Do

- **Firmware building** → `ats-fw-esp32-demo`
- **Pure test logic** → `ats-test-esp32-demo` (test runner is hardware-agnostic)
- **CI orchestration** → `ats-ci-infra`

---

## 👤 Author

**Hai Dang Son**  
Senior Embedded / Embedded Linux / IoT Engineer
