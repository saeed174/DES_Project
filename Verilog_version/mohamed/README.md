# System Verification & Testbench — Mohamed

## Overview & Role
**Owner:** Mohamed  
**Responsibility:** End-to-end simulation testbenches, automated test scripts, and regression verification for the Verilog RTL implementation.

---

## Deliverables & Modules

### 1. Basic Unit Testbench
- **`tb_des.v`**
  - Tests Initial Permutation loopback.
  - Verifies known-answer standard vector from the assignment.
  - Tests all-zero vector encryption and decryption recovery.

### 2. Comprehensive Testbench
- **`tb_des_comprehensive.v`**
  - **Section 1 (Permutation Inversion):** 16 random 64-bit blocks testing $IP^{-1}(IP(X)) == X$.
  - **Section 2 (Standard KAT Vectors):** 6 standard test vectors (NIST & Assignment) with automatic decrypt-recovery check.
  - **Section 3 (Cryptographic Complementarity):** Validates $\text{DES}(\sim K, \sim P) == \sim\text{DES}(K, P)$.
  - **Section 4 (Avalanche Effect):** Flips each input bit individually and measures non-linear diffusion (~49% bit flip).
  - **Section 5 (Random Regression):** 100 randomized key/plaintext encrypt-decrypt roundtrips.

---

## How to Run Simulation

### Using QuestaSim / ModelSim DO Script:
```bash
cd "d:/ASU/Senior 2/1st/Security/DES Project/Verilog_version"
vsim -c -do "do run.do; quit -f"
```
Or in the GUI:
```tcl
do run.do
```

### Results Summary
- **130 / 130 tests passed with 0 failures.**
