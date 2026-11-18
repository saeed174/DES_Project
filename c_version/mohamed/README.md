# Binary File I/O, ECB Mode CLI & Verification Suite — Mohamed

## Overview & Role
**Owner:** Mohamed  
**Responsibility:** Command-line interface (CLI), binary file reading/writing, ECB block processing, and automated C unit testing suite.

---

## Deliverables & Modules

### 1. Main CLI Program (`main.c`)
- **`main.c`**
  - Implements the required assignment command syntax:
    ```bash
    # Encryption:
    ./des_cli e key_file plaintext_file ciphertext_file

    # Decryption:
    ./des_cli d key_file ciphertext_file plaintext_file
    ```
  - Parses keys in both 16-hex character format or 8-byte raw binary format.
  - Reads and writes in binary mode (`"rb"` and `"wb"`), safely preserving all binary values (including `0x00`).
  - Processes whole files in 8-byte blocks under Electronic Codebook (ECB) mode.

### 2. Comprehensive Test Suite (`test_des.c`)
- **`test_des.c`**
  - Section 1: 50 random permutation loopback checks.
  - Section 2: Standard NIST and project known-answer vectors.
  - Section 3: DES complementarity property check.
  - Section 4: 1,000 randomized key/plaintext roundtrips.

---

## How to Build & Run (from `c_version/`)

### 1. Build & Run the Test Suite:
```bash
gcc -O3 -Wall -Wextra zeyad/*.c lotfy/*.c marc/*.c saeed/*.c mohamed/test_des.c -o test_des_c.exe
.\test_des_c.exe
```

### 2. Build & Run the Official CLI Tool:
```bash
# Build
gcc -O3 -Wall -Wextra zeyad/*.c lotfy/*.c marc/*.c saeed/*.c mohamed/main.c -o des_cli.exe

# Encrypt & Decrypt (using tests/ .txt files)
.\des_cli.exe e tests/keys/key_ascii_hex_nl.txt tests/plaintexts/pt_kat5_ascii.txt ciphertext.txt
.\des_cli.exe d tests/keys/key_ascii_hex_nl.txt ciphertext.txt decrypted.txt
```
