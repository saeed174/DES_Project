# Data Encryption Standard (DES) Project

An end-to-end, dual-track implementation of the **Data Encryption Standard (DES)** conforming to NIST FIPS PUB 46-3, developed both in **SystemVerilog/Verilog HDL** and in **ANSI C**.

---

## 👥 Team Ownership & Work Partitioning

The architecture is partitioned into five distinct layers, each owned by one team member across both the Verilog and C implementations:

| Member | Role & Layer | Primary Modules & Responsibilities |
| :--- | :--- | :--- |
| **Zeyad** | **Permutation Layer** | Initial Permutation ($IP$), Inverse Initial Permutation ($IP^{-1}$), Expansion ($E$), and Permutation ($P$). |
| **Lotfy** | **Key Schedule** | Permuted Choice 1 (PC-1), 28-bit circular left shifts, Permuted Choice 2 (PC-2), and 16 round subkeys generation ($K_1 \dots K_{16}$). |
| **Marc** | **S-Boxes & Round Function $F$** | Eight non-linear substitution boxes ($S_1 \dots S_8$), row/column extraction, parallel 48-to-32 bit substitution, and $F(R, K)$ integration. |
| **Saeed** | **DES Core & Feistel Network** | 16-round Feistel network data path, subkey inversion for decryption, pre-output block swap $\{R_{16}, L_{16}\}$, and top-level integration. |
| **Mohamed** | **I/O, CLI & System Testbench** | Binary file I/O (preserving `0x00`), ECB multi-block iteration, CLI argument parsing, automated QuestaSim simulation script (`run.do`), and comprehensive test suites. |

---

## 📁 Repository Structure

```
DES Project/
├── Verilog_version/                       # Complete RTL implementation
│   ├── zeyad/                             # IP, IP^-1, E, P permutation modules
│   │   ├── des_initial_permutation.v
│   │   ├── des_inverse_initial_permutation.v
│   │   ├── des_expansion_permutation.v
│   │   ├── des_p_permutation.v
│   │   └── README.md
│   ├── lotfy/                             # Key schedule modules
│   │   ├── des_pc1.v
│   │   ├── des_pc2.v
│   │   ├── des_key_schedule.v
│   │   └── README.md
│   ├── marcelino/                              # S-Boxes & Round function F
│   │   ├── des_sbox_1.v ... des_sbox_8.v
│   │   ├── des_sboxes_all.v
│   │   ├── des_round_function_f.v
│   │   └── README.md
│   ├── saeed/                             # Feistel rounds & Core assembly
│   │   ├── des_feistel_round.v
│   │   ├── des_core.v
│   │   └── README.md
│   ├── mohamed/                           # System testbenches
│   │   ├── tb_des.v
│   │   ├── tb_des_comprehensive.v
│   │   └── README.md
│   └── run.do                             # Automated QuestaSim/ModelSim run script
│
├── c_version/                             # Complete ANSI C implementation
│   ├── zeyad/                             # des_permutation.h / .c & README.md
│   ├── lotfy/                             # des_key_schedule.h / .c & README.md
│   ├── marcelino/                              # des_round_function.h / .c & README.md
│   ├── saeed/                             # des_core.h / .c & README.md
│   └── mohamed/                           # main.c, test_des.c & README.md
│
└── README.md                              # This file
```

---

## 🚀 Getting Started

### 1. Running the Verilog Simulation (QuestaSim / ModelSim)

Open QuestaSim or ModelSim in the `Verilog_version/` directory:

#### Option A: Inside QuestaSim GUI
```tcl
cd Verilog_version
do run.do
```
*The `run.do` script automatically compiles all modules in dependency order, elaborates the design with full visibility (`+acc`), groups and formats waveforms (Inputs, Output, Internal Datapath, Pass/Fail counters), runs all 130 tests, and zooms to fit.*

#### Option B: From Command Line / Terminal
```bash
cd Verilog_version
vsim -c -do "do run.do; quit -f"
```

---

### 2. Building and Running the C Version

Ensure GCC is available on your system.

#### Running the Comprehensive C Test Suite:
```bash
gcc -O3 -Wall -Wextra c_version/zeyad/*.c c_version/lotfy/*.c c_version/marc/*.c c_version/saeed/*.c c_version/mohamed/test_des.c -o test_des_c.exe
./test_des_c.exe
```

#### Building the Binary File Encryption/Decryption CLI:
```bash
gcc -O3 -Wall -Wextra c_version/zeyad/*.c c_version/lotfy/*.c c_version/marc/*.c c_version/saeed/*.c c_version/mohamed/main.c -o des_cli.exe
```

#### Using the CLI (Assignment Format):
```bash
# Encrypt an 8-byte aligned file in ECB mode:
./des_cli.exe e key_file.txt plaintext.bin ciphertext.bin

# Decrypt the file back to plaintext:
./des_cli.exe d key_file.txt ciphertext.bin recovered_plaintext.bin
```
> **Key file format:** Accepts either 16 hexadecimal characters (e.g., `133457799BBCDFF1`) or 8 raw binary bytes.

---

## 🧪 Verification Matrix & Acceptance Criteria

Both the Verilog and C implementations undergo rigorous automated testing covering all standard cryptographic requirements:

| Test Category | Description | Verilog RTL | C Version |
| :--- | :--- | :---: | :---: |
| **Permutation Inversion** | Verifies mathematical identity $IP^{-1}(IP(X)) \equiv X$ across random 64-bit blocks. | ✅ Passed | ✅ Passed |
| **Standard Assignment KAT** | `Key: 133457799BBCDFF1`<br>`PT:  0123456789ABCDEF`<br>`CT:  85E813540F0AB405` | ✅ Passed | ✅ Passed |
| **NIST SP 800-20 Vectors** | All-zero key/data (`CT: 8CA64DE9C1B123A7`), 56-bit key patterns, all-ones plaintext (`0xFFFFFFFFFFFFFFFF`), and ASCII test vectors. | ✅ Passed | ✅ Passed |
| **Plaintext Recovery** | Decrypting ciphertext recovers original plaintext with 0 bit errors. | ✅ Passed | ✅ Passed |
| **Cryptographic Complementarity** | Validates DES property: $\text{DES}(\sim K, \sim P) \equiv \sim\text{DES}(K, P)$. | ✅ Passed | ✅ Passed |
| **Avalanche Diffusion Effect** | Single-bit input changes produce ~49% bit flips in ciphertext (statistical standard is ~50%). | ✅ Passed | ✅ Passed |
| **Randomized Regression** | Continuous automated round-trip encrypt-decrypt cycles (100 in RTL, 1,000 in C) with 100% recovery. | ✅ Passed | ✅ Passed |

---

## 📜 Standards & References
- **FIPS PUB 46-3:** Data Encryption Standard (DES), National Institute of Standards and Technology (NIST).
- **NIST Special Publication 800-20:** Modes of Operation Validation System for the Triple Data Encryption Algorithm (TDEA).
