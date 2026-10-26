# DES Core & Feistel Network — Saeed

## Overview & Role
**Owner:** Saeed  
**Responsibility:** DES 16-round Feistel datapath and block encryption/decryption in C.

---

## Files & Functions

- **`des_core.h`**:
  Exposes the 64-bit block encryption and decryption interfaces:
  - `uint64_t des_encrypt_block(uint64_t block, uint64_t key);`
  - `uint64_t des_decrypt_block(uint64_t block, uint64_t key);`
- **`des_core.c`**:
  - `des_process_block(block, key, decrypt)`:
    Coordinates key expansion from Lotfy, initial permutation from Zeyad, 16 Feistel rounds with $F(R, K)$ from Marc, swap of final halves, and inverse permutation from Zeyad.

---

## Verification
- Verified against the project known-answer vector:
  - `Key: 0x133457799BBCDFF1`, `PT: 0x0123456789ABCDEF` $\rightarrow$ `CT: 0x85E813540F0AB405`.
- Decryption exactly recovers the plaintext with 0 bit errors.
