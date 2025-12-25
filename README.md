# ATS Node

> **ATS agent scripts for flashing, testing, audit, and metrics**

The ATS node is the execution and observation plane of the ATS platform. It is intentionally separated from CI infrastructure to ensure deterministic hardware access, reliable test execution, and reproducible results on real devices.

---

## 📁 Repository Structure

```
ats-ats-node/
├── README.md
├── agent/
│   ├── flash_fw.py
│   ├── power_control.py
│   ├── uart_logger.py
│   ├── gpio_reader.py
│   ├── camera_capture.py
│   ├── ai_validator.py
│   └── test_runner.py
├── exporters/
│   └── prometheus_exporter.py
└── tests/
    └── test_gpio_oled.py
```

---

## 🎯 Role of the ATS Node

The ATS node provides:

- **Hardware access** (UART, GPIO, power control)
- **Firmware flashing** capabilities
- **Test execution** infrastructure
- **Metrics export** for Prometheus
- **Observation tools** (camera, UART logging)

---

## 🔗 Relationship to Other Repositories

- **`ats-ci-infra`**: Receives test jobs and artifacts from Jenkins
- **`ats-test-esp32-demo`**: Test execution framework that uses these tools
- **`ats-fw-esp32-demo`**: Consumes firmware artifacts for testing
- **`ats-platform-docs`**: System architecture documentation

---

## 📊 Status

**Current Status: Placeholder / Future Enhancement**

This repository is intended to provide low-level Python-based hardware access and observation tools. Currently, the working implementation uses shell scripts in `ats-test-esp32-demo`.

**Current Implementation:**
- `ats-test-esp32-demo` contains working shell scripts for hardware access (flash_fw.sh, run_tests.sh, etc.)
- This repository (`ats-ats-node`) is a placeholder for future Python-based tools

**Future Direction:**
- This repository will provide Python modules for:
  - Hardware abstraction layer
  - Advanced power control
  - Camera-based validation
  - AI-based test validation
  - Prometheus metrics export
- `ats-test-esp32-demo` will optionally use these Python tools while maintaining shell script compatibility

**Decision: Keep Separate**
- This repository serves as a foundation for advanced features
- Shell scripts in `ats-test-esp32-demo` remain the primary working implementation
- Python tools here will be optional enhancements

---

## 👤 Author

**Hai Dang Son**  
Senior Embedded / Embedded Linux / IoT Engineer
