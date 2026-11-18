# DES C Implementation — Build & Run Guide

This folder contains the **C implementation** of the Data Encryption Standard (DES, FIPS PUB 46-3), including:
- Modular DES library components (`zeyad/`, `lotfy/`, `marc/`, `saeed/`)
- A binary-safe ECB file encryption/decryption CLI (`mohamed/main.c`)
- An automated verification suite (`mohamed/test_des.c`)
- Pre-built Windows executables (`des_cli.exe`, `test_des_c.exe`)
- Test keys and plaintext vectors (`tests/`)

---

## 📍 Where to Run Commands

Open a terminal and navigate into the **`c_version/`** directory inside the repository:

```bash
cd DES_Project/c_version
```

> **Note:** All relative file paths in the commands below (such as `zeyad/*.c` and `tests/keys/...`) assume your working directory is **`c_version/`**.
> If you are in the repository root (`DES_Project/`), either `cd c_version` first or prefix the paths with `c_version/`.

---

## 📁 Folder Layout

```text
c_version/
├── des_cli.exe                  # Pre-built Windows CLI executable
├── test_des_c.exe               # Pre-built Windows verification suite executable
├── zeyad/                       # Permutation layer (IP, IP^-1, E, P)
│   ├── des_permutation.h
│   ├── des_permutation.c
│   └── README.md
├── lotfy/                       # Key schedule (PC-1, circular shifts, PC-2)
│   ├── des_key_schedule.h
│   ├── des_key_schedule.c
│   └── README.md
├── marc/                        # S-Boxes (S1..S8) & Round Function F(R, K)
│   ├── des_round_function.h
│   ├── des_round_function.c
│   └── README.md
├── saeed/                       # 16-round Feistel DES core (encrypt/decrypt block)
│   ├── des_core.h
│   ├── des_core.c
│   └── README.md
├── mohamed/                     # CLI application & verification test suite
│   ├── main.c
│   ├── test_des.c
│   └── README.md
└── tests/                       # Test keys, plaintexts, and expected ciphertext matrix
    ├── keys/
    ├── plaintexts/
    └── README.md
```

---

## ⚡ Quick Start (Windows Pre-built Executables)

If you are on Windows and have not modified the C source files, you can run the pre-built executables directly from **`c_version/`**:

### 1. Run the Verification Suite
**PowerShell / Command Prompt (`cmd`):**
```powershell
.\test_des_c.exe
```

**Git Bash:**
```bash
./test_des_c.exe
```

### 2. Run the Encryption / Decryption CLI
**PowerShell / Command Prompt (`cmd`):**
```powershell
# Encrypt
.\des_cli.exe e tests/keys/key_ascii_hex_nl.txt tests/plaintexts/pt_kat5_ascii.txt ciphertext.bin

# Decrypt
.\des_cli.exe d tests/keys/key_ascii_hex_nl.txt ciphertext.bin decrypted.txt
```

---

## 🛠️ Building from Source

### Prerequisites
- A C99-compatible compiler such as **GCC** (MinGW-w64 on Windows, GCC on Linux/macOS) or **Clang**.

### 1. Build & Run the Verification Suite (`mohamed/test_des.c`)

From **`c_version/`**:

**Windows (PowerShell / Command Prompt):**
```powershell
gcc -O3 -Wall -Wextra zeyad/*.c lotfy/*.c marc/*.c saeed/*.c mohamed/test_des.c -o test_des_c.exe
.\test_des_c.exe
```

**Linux / macOS / Git Bash:**
```bash
gcc -O3 -Wall -Wextra zeyad/*.c lotfy/*.c marc/*.c saeed/*.c mohamed/test_des.c -o test_des_c
./test_des_c
```

**What it tests (13 summary checks):**
1. **Permutation Identity:** 50 random 64-bit checks verifying $IP^{-1}(IP(X)) = X$.
2. **Known-Answer Tests (KAT 1–5):** Encrypt + decrypt recovery on standard assignment and NIST vectors.
3. **Complementarity Property:** Verifies $\text{DES}(\sim K, \sim P) = \sim\text{DES}(K, P)$.
4. **Randomized Roundtrips:** 1,000 random key/plaintext encrypt-decrypt cycles.

---

### 2. Build the File Encryption/Decryption CLI (`mohamed/main.c`)

From **`c_version/`**:

**Windows (PowerShell / Command Prompt):**
```powershell
gcc -O3 -Wall -Wextra zeyad/*.c lotfy/*.c marc/*.c saeed/*.c mohamed/main.c -o des_cli.exe
```

**Linux / macOS / Git Bash:**
```bash
gcc -O3 -Wall -Wextra zeyad/*.c lotfy/*.c marc/*.c saeed/*.c mohamed/main.c -o des_cli
```

---

## 🚀 Using the CLI (`des_cli`)

### Command Syntax
```text
des_cli <e|d> <key_file> <input_file> <output_file>
```
- `e` — Encrypt `<input_file>` to `<output_file>`
- `d` — Decrypt `<input_file>` to `<output_file>`

### Input & Key File Formats
- **Key file (`<key_file>`):**
  - **16 hexadecimal characters** (e.g. `133457799BBCDFF1`), optionally followed by `\n`, `\r`, or space; **or**
  - **8 raw binary bytes** (interpreted in big-endian byte order; files shorter than 8 bytes are rejected).
- **Data files (`<input_file>`, `<output_file>`):**
  - Opened in binary mode (`"rb"` / `"wb"`), preserving all byte values including `0x00`.
  - Processed in **8-byte ECB blocks**. Any trailing partial block (< 8 bytes) is zero-padded to 8 bytes.

### Examples (Run from `c_version/`)

**Example 1 — Assignment Known-Answer Vector (KAT 1):**
```powershell
# Encrypt tests/plaintexts/pt_kat1.txt (0123456789ABCDEF) with key 133457799BBCDFF1
.\des_cli.exe e tests/keys/key_kat1_hex.txt tests/plaintexts/pt_kat1.txt kat1_out.bin

# Decrypt back to recover the original bytes
.\des_cli.exe d tests/keys/key_kat1_hex.txt kat1_out.bin kat1_recovered.bin
```
Expected `kat1_out.bin` bytes (hex): `85 E8 13 54 0F 0A B4 05`.

**Example 2 — Readable ASCII Text (KAT 5):**
```powershell
.\des_cli.exe e tests/keys/key_ascii_hex_nl.txt tests/plaintexts/pt_kat5_ascii.txt kat5_out.bin
.\des_cli.exe d tests/keys/key_ascii_hex_nl.txt kat5_out.bin kat5_recovered.txt
```
Expected `kat5_out.bin` bytes (hex): `3F A4 0E 8A 98 4D 48 15`, and `kat5_recovered.txt` contains `Now is t`.

See [`tests/README.md`](./tests/README.md) for the full 12-vector test matrix using all files in `tests/keys/` and `tests/plaintexts/`.

---

## 🧩 Integrating Into Your Own C Code

Include [`saeed/des_core.h`](./saeed/des_core.h) to call single-block encryption/decryption directly:
```c
#include "saeed/des_core.h"

uint64_t ct = des_encrypt_block(plaintext_block, key);
uint64_t pt = des_decrypt_block(ct, key);
```
Compile your source file together with `zeyad/*.c`, `lotfy/*.c`, `marc/*.c`, and `saeed/*.c`.
