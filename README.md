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

This repository provides the low-level hardware access and observation tools. Higher-level test logic is implemented in `ats-test-esp32-demo`.

---

## 👤 Author

**Hai Dang Son**  
Senior Embedded / Embedded Linux / IoT Engineer
