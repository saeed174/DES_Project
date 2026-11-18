# DES C-Version Test Key & Plaintext Files

All test key and plaintext files use the `.txt` extension for exercising `mohamed/main.c` (`des_cli`) across 16-char hex keys, 8-char ASCII keys, binary-safe file I/O, Known-Answer Tests (KATs), DES algebraic properties, and multi-block ECB behavior.

## Key Files (`tests/keys/`)

All key files are plain ASCII `.txt` files:

| File | Size | Format | 64-bit Key (`hex`) | Purpose |
|---|---:|---|---|---|
| `key_kat1_hex.txt` | 16 B | ASCII hex (exact 16 B) | `0x133457799BBCDFF1` | Project Assignment KAT 1 |
| `key_kat1_hex_space.txt` | 17 B | ASCII hex + trailing space | `0x133457799BBCDFF1` | Tests trailing-space hex parsing (`buf[16] == ' '`) |
| `key_all_zero_hex.txt` | 16 B | ASCII hex | `0x0000000000000000` | NIST All-Zero key (KAT 2) |
| `key_nist_56bit_hex.txt` | 16 B | ASCII hex | `0x3800505708B62100` | NIST 56-bit Key Pattern A (KAT 3) |
| `key_kat4_hex_crlf.txt` | 18 B | ASCII hex + `\r\n` | `0x04B915BA43FEB5B6` | KAT 4 key with Windows CRLF newline |
| `key_ascii_hex_nl.txt` | 17 B | Lowercase hex + `\n` | `0x0123456789ABCDEF` | Lowercase hex + LF newline (KAT 5 & 24 B vector) |
| `key_kat1_comp_hex.txt` | 16 B | ASCII hex | `0xECCBA8866443200E` | Bitwise complement of KAT 1 key (`~K`) |
| `key_ctrl_test_hex.txt` | 16 B | ASCII hex | `0x011A0D0A00FEDCBA` | Hex key paired with binary control-byte plaintext |
| `key_weak_hex.txt` | 16 B | ASCII hex | `0x0101010101010101` | DES weak key (`E(K, E(K, P)) == P`) |
| `key_ascii_8char.txt` | 8 B | 8-char ASCII text (`MySecKey`) | `0x4D795365634B6579` | Tests the 8-byte raw-byte fallback in `read_key_file` |

## Plaintext Files (`tests/plaintexts/`)

> **Note:** `main.c` encrypts plaintext files as raw bytes (not hex strings). Therefore `pt_kat1.txt`, `pt_all_zero.txt`, `pt_all_ones.txt`, `pt_kat1_comp.txt`, and `pt_binary_ctrl.txt` store raw 8-byte / 16-byte KAT test patterns inside `.txt` files, while the remaining files contain readable ASCII text.

| File | Size | Blocks | Content / Purpose |
|---|---:|---:|---|
| `pt_kat1.txt` | 8 B | 1 | Raw bytes `01 23 45 67 89 AB CD EF` (Project Assignment KAT 1) |
| `pt_all_zero.txt` | 8 B | 1 | Raw bytes `00 00 00 00 00 00 00 00` (NIST KAT 2 & KAT 3) |
| `pt_all_ones.txt` | 8 B | 1 | Raw bytes `FF FF FF FF FF FF FF FF` (KAT 4) |
| `pt_kat5_ascii.txt` | 8 B | 1 | `Now is t` (KAT 5 single-block ASCII) |
| `pt_multiblock_ascii.txt` | 24 B | 3 | `Now is the time for all ` (standard 3-block ECB vector) |
| `pt_ecb_repeated.txt` | 32 B | 4 | `BLOCK_A!BLOCK_A!BLOCK_B!BLOCK_A!` (identical blocks encrypt identically in ECB) |
| `pt_kat1_comp.txt` | 8 B | 1 | Raw bytes `FE DC BA 98 76 54 32 10` (bitwise complement `~P` of KAT 1) |
| `pt_binary_ctrl.txt` | 16 B | 2 | Binary control bytes (`0x00`, `0x0A`, `0x0D`, `0x1A`, `0xFF`, etc.) |
| `pt_unaligned.txt` | 13 B | 2 | `Hello, World!` (tests zero-padding of partial final block to 16 B) |
| `pt_large_message.txt` | 128 B | 16 | 4-line multi-block ASCII text message (exact 128 bytes) |

## Test Matrix & Expected Ciphertexts

| Test Case | Key File | Plaintext File | Expected Ciphertext (Hex) |
|---|---|---|---|
| KAT 1 (Hex Key) | `key_kat1_hex.txt` | `pt_kat1.txt` | `85E813540F0AB405` |
| KAT 1 (Trailing Space) | `key_kat1_hex_space.txt` | `pt_kat1.txt` | `85E813540F0AB405` |
| KAT 2 (All-Zero) | `key_all_zero_hex.txt` | `pt_all_zero.txt` | `8CA64DE9C1B123A7` |
| KAT 3 (NIST 56-bit) | `key_nist_56bit_hex.txt` | `pt_all_zero.txt` | `479B96735B573BEB` |
| KAT 4 (All-Ones, CRLF) | `key_kat4_hex_crlf.txt` | `pt_all_ones.txt` | `719D2F7265F7FF7B` |
| KAT 5 (ASCII, LF) | `key_ascii_hex_nl.txt` | `pt_kat5_ascii.txt` | `3FA40E8A984D4815` |
| Complementarity (`~K, ~P`) | `key_kat1_comp_hex.txt` | `pt_kat1_comp.txt` | `7A17ECABF0F54BFA` |
| Multi-Block ASCII (24 B) | `key_ascii_hex_nl.txt` | `pt_multiblock_ascii.txt` | `3FA40E8A984D48156A271787AB8883F9893D51EC4B563B53` |
| ECB Repeated Blocks (32 B) | `key_kat1_hex.txt` | `pt_ecb_repeated.txt` | `775239A9452E7EED775239A9452E7EEDCE9DF4545E13995B775239A9452E7EED` |
| Binary Control Bytes (16 B) | `key_ctrl_test_hex.txt` | `pt_binary_ctrl.txt` | `933AEA5AE781478E6473AF53AC4EEDE4` |
| Unaligned Zero-Pad (13->16 B) | `key_ascii_8char.txt` | `pt_unaligned.txt` | `0789DF29B435556B18A9CC28C7B85F23` |
| Weak Key Involution (`E(K,E(K,P))==P`) | `key_weak_hex.txt` | `pt_kat5_ascii.txt` | `7D65484BE578DD0D` |

## Example Commands (from `c_version/`)

```cmd
# Build CLI
gcc -O3 -Wall -Wextra zeyad/*.c lotfy/*.c marc/*.c saeed/*.c mohamed/main.c -o des_cli.exe

# Encrypt & decrypt
.\des_cli.exe e tests/keys/key_ascii_hex_nl.txt tests/plaintexts/pt_kat5_ascii.txt ciphertext.txt
.\des_cli.exe d tests/keys/key_ascii_hex_nl.txt ciphertext.txt decrypted.txt
```
