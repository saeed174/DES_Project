# DES C-Version Binary Test Samples (Stallings Chapter 4)

All test key, plaintext, and expected ciphertext files in `tests/` are **8-byte raw binary `.bin` files** derived from **William Stallings, *Cryptography and Network Security: Principles and Practice* (8th ed., 2023), Chapter 4, Section 4.3 (Tables 4.2–4.4)**.

---

## Key Files (`tests/keys/`)

| File | Size | Raw Bytes (Hex) | Reference |
|---|---:|---|---|
| `key_table4_2.bin` | 8 B | `0F 15 71 C9 47 D9 E8 59` | Stallings Table 4.2 & Table 4.3 key |
| `key_table4_4_avalanche.bin` | 8 B | `1F 15 71 C9 47 D9 E8 59` | Stallings Table 4.4 key (1-bit flip from `0x0F...` to `0x1F...`) |

## Plaintext Files (`tests/plaintexts/`)

| File | Size | Raw Bytes (Hex) | Reference |
|---|---:|---|---|
| `pt_table4_2.bin` | 8 B | `02 46 8A CE EC A8 64 20` | Stallings Table 4.2 & Table 4.4 plaintext |
| `pt_table4_3_avalanche.bin` | 8 B | `12 46 8A CE EC A8 64 20` | Stallings Table 4.3 plaintext (1-bit flip from `0x02...` to `0x12...`) |

## Expected Ciphertext Files (`tests/ciphertexts/`)

| File | Size | Raw Bytes (Hex) | Reference |
|---|---:|---|---|
| `ct_table4_2.bin` | 8 B | `DA 02 CE 3A 89 EC AC 3B` | Stallings Table 4.2 expected ciphertext |
| `ct_table4_3_avalanche.bin` | 8 B | `05 7C DE 97 D7 68 3F 2A` | Stallings Table 4.3 expected ciphertext (`32` differing bits) |
| `ct_table4_4_avalanche.bin` | 8 B | `EE 92 B5 06 06 B6 2B 0B` | Stallings Table 4.4 expected ciphertext (`30` differing bits) |

---

## Test Matrix

| Sample | Key File | Plaintext File | Expected Ciphertext File |
|---|---|---|---|
| **Table 4.2 (DES Example)** | `tests/keys/key_table4_2.bin` | `tests/plaintexts/pt_table4_2.bin` | `tests/ciphertexts/ct_table4_2.bin` (`DA02CE3A89ECAC3B`) |
| **Table 4.3 (Plaintext Avalanche)** | `tests/keys/key_table4_2.bin` | `tests/plaintexts/pt_table4_3_avalanche.bin` | `tests/ciphertexts/ct_table4_3_avalanche.bin` (`057CDE97D7683F2A`) |
| **Table 4.4 (Key Avalanche)** | `tests/keys/key_table4_4_avalanche.bin` | `tests/plaintexts/pt_table4_2.bin` | `tests/ciphertexts/ct_table4_4_avalanche.bin` (`EE92B50606B62B0B`) |

---

## Example Commands (from `c_version/`)

```powershell
# Build CLI
gcc -O3 -Wall -Wextra permutation/*.c key_schedule/*.c round_function/*.c des_core/*.c cli_and_tests/main.c -o des_cli.exe

# Sample 1: Stallings Table 4.2 (Encrypt, compare with expected .bin, and Decrypt)
.\des_cli.exe e tests/keys/key_table4_2.bin tests/plaintexts/pt_table4_2.bin out_table4_2.bin
fc /b out_table4_2.bin tests\ciphertexts\ct_table4_2.bin
.\des_cli.exe d tests/keys/key_table4_2.bin out_table4_2.bin recovered_table4_2.bin
fc /b recovered_table4_2.bin tests\plaintexts\pt_table4_2.bin

# Sample 2: Stallings Table 4.3 (Plaintext Avalanche)
.\des_cli.exe e tests/keys/key_table4_2.bin tests/plaintexts/pt_table4_3_avalanche.bin out_table4_3.bin
fc /b out_table4_3.bin tests\ciphertexts\ct_table4_3_avalanche.bin

# Sample 3: Stallings Table 4.4 (Key Avalanche)
.\des_cli.exe e tests/keys/key_table4_4_avalanche.bin tests/plaintexts/pt_table4_2.bin out_table4_4.bin
fc /b out_table4_4.bin tests\ciphertexts\ct_table4_4_avalanche.bin
```
