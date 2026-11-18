# Key Schedule & Round Subkeys — Lotfy

## Overview & Role
**Owner:** Lotfy  
**Responsibility:** Key expansion and round subkey generation in C.

---

## Files & Functions

- **`des_key_schedule.h`**:
  Exposes the subkey generation API.
- **`des_key_schedule.c`**:
  - `void des_generate_subkeys(uint64_t key, uint64_t subkeys[16])`:
    Extracts 56 bits via PC-1, rotates halves according to the per-round shift schedule (1 or 2 bits), and compresses them via PC-2 into 16 48-bit subkeys.

---

## Verification
- Verified against the standard DES specification test vector and NIST vectors.
- Subkey bit widths and rotation values adhere to FIPS PUB 46-3.
