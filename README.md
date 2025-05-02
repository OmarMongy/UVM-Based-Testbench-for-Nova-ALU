# Verification UVM Framework for Nova ALU

![SystemVerilog](https://img.shields.io/badge/language-SystemVerilog-blue.svg)
![Verilog](https://img.shields.io/badge/language-Verilog-yellow.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![Status](https://img.shields.io/badge/status-active-brightgreen.svg)

This project provides a **Universal Verification Methodology (UVM)**-based testbench for verifying an **Arithmetic Logic Unit (ALU)** design. It includes a reusable and configurable verification environment capable of testing edge cases, reset scenarios, and normal operations.

---

## 📑 Table of Contents

- [Features](#features)
- [Directory Structure](#directory-structure)
- [Testbench Components](#testbench-components)
- [Getting Started](#getting-started)
- [Running Simulation](#running-simulation)
- [Tests Included](#tests-included)
- [Contributing](#contributing)
- [License](#license)

---

## ✅ Features

- UVM-compliant modular testbench
- Random and constrained stimulus generation
- Reset and functional coverage sequences
- Edge case testing (0s, 1s, overflow conditions)
- Scalable and reusable components

---

## 📁 Directory Structure

```
alu_uvm_verif/
├── components/
│   ├── alu_env.sv
│   ├── alu_scoreboard.sv
│   ├── alu_coverage.sv
│   ├── alu_env_config.sv
│   ├── alu_agent.sv
│   ├── alu_config.sv
│   ├── alu_driver.sv
│   ├── alu_monitor.sv
│   └── alu_sequencer.sv
├── objects/
│   ├── alu_item_base.sv
│   ├── alu_item_drv.sv
│   ├── alu_item_mon.sv
│   ├── alu_sequence_base.sv
│   ├── alu_sequence_reset.sv
│   ├── alu_sequence_simple.sv
├── pkgs/
│   ├── alu_agent_pkg.sv
│   ├── alu_env_pkg.sv
│   └── alu_test_pkg.sv
├── sim/
│   └── testbench.sv
│   └── src/
│       ├── alu_if.sv
│       └── nova_alu.v
├── tests/
│   ├── alu_basic_operations_test.sv
│   ├── alu_edge_case_test.sv
│   └── alu_test_base.sv
├── README.m
```

---

## 🧩 Testbench Components

| Component       | Description                                        |
|----------------|----------------------------------------------------|
| `alu_if`        | Defines signal-level interface for DUT            |
| `alu_item_drv`  | Defines sequence item (stimulus transaction)      |
| `alu_driver`    | Drives stimulus to DUT from sequencer             |
| `alu_monitor`   | Observes DUT outputs and forwards to scoreboard   |
| `alu_sequencer` | Controls order of stimulus to be driven           |
| `alu_agent`     | Bundles sequencer, driver, monitor                |
| `alu_env`       | Top-level environment holding agents              |
| `alu_config`    | Holds configuration objects (e.g., active/passive)|
| `alu_test_base` | Base test class with environment instantiation    |
| `alu_sequence_*`| Various test sequences for stimulus               |
| `*_test`        | Specific test scenarios for coverage              |

---

## 🚀 Getting Started

### ✅ Prerequisites

- SystemVerilog simulator (e.g., **Mentor ModelSim/Questa**, **VCS**, or **Xrun**)
- UVM library installed or included via simulator flags
- Make or TCL-based run environment

### 🔧 Compilation Setup

Example using ModelSim:

```tcl
vlib work
vlog +acc=rn +define+UVM_NO_DPI src/*.sv +incdir+src
vsim -c -do "run -all; quit" alu_basic_operations_test
```

Or via Makefile (if provided):

```bash
make test TEST=alu_edge_case_test
```

---

## 🧪 Tests Included

| Test Name               | Description                                     |
|------------------------|-------------------------------------------------|
| `alu_basic_operations_test` | Validates basic ALU functionality using fixed operands |
| `alu_edge_case_test`        | Applies edge values (0s, 1s) for robustness testing    |

---

## 🧠 Example Output

```
UVM_INFO @ 0: uvm_test_top [DEBUG] this is the end of the test
UVM_INFO @ 0: reporter [TEST_DONE] UVM TEST PASSED
```

---

## 🤝 Contributing

Contributions are welcome! You can:

- Suggest additional test scenarios
- Improve sequence constraints
- Add coverage and scoreboard enhancements

Fork the repo, create a feature branch, and submit a PR.

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).

---

## ✍️ Authors

Developed and maintained by [Your Name or Team Name].
