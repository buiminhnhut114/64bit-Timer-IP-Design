# 64-bit Timer IP Design

## Overview
This project presents the design and implementation of a **64-bit Timer IP core** compatible with the **AMBA APB (Advanced Peripheral Bus)** protocol.  
The Timer IP supports both **standard** and **advanced** operational modes, offering precise time tracking, interrupt generation, and flexible configuration options suitable for embedded systems.

---

## Features
- **64-bit Up-Counter** with a 4KB APB address space (`0x4000_1000` to `0x4000_1FFF`).
- **APB Slave Interface** for register access.
- **Byte-wise and Half-word Access**.
- **Wait State Insertion** and **Error Handling** for invalid accesses.
- **Programmable Counting Speed** via `div_en` and `div_val` fields in the Timer Control Register (TCR).
- **Interrupt Generation** upon reaching a compare value (if enabled).
- **Halt Control** to stop the timer during debug mode.
- **System Clock Frequency**: 200 MHz.

---

## System Architecture
The design is divided into modular components:
1. **APB Interface** – Handles bus communication and data transfers.
2. **Register Block** – Stores configuration and status registers.
3. **Counter Logic** – Implements the 64-bit up-counter.
4. **Control Unit** – Manages operational modes and configurations.
5. **Interrupt Generator** – Triggers interrupts when compare values are reached.

---

## Tools & Technologies
- **HDL**: Verilog
- **Simulation**: ModelSim / QuestaSim
- **Environment**: Linux server (MobaXterm access)
- **Documentation**: PDF Report included in repository

---

## File Structure
```
rtl/         # RTL design files (Verilog)
tb/          # Testbench modules
testcases/   # Functional test cases for verification
sim/         # Simulation scripts, logs, and configurations
docs/        # Documentation and diagrams
```
---

## Verification
- Comprehensive simulation using self-written testbenches.
- Functional coverage: **90%** achieved.
- Verified timing at **200 MHz** with stable operation.

---

## Author
**Bui Minh Nhut**  
- Email: your_email_here  
- GitHub: your_github_profile_link
