# S-Boxes & Round Function F — Marc

## Overview & Role
**Owner:** Marc  
**Responsibility:** DES non-linear substitution boxes and round function $F(R, K)$ in C.

---

## Files & Functions

- **`des_round_function.h`**:
  Exposes S-Boxes lookup and $F(R, K)$ function prototypes.
- **`des_round_function.c`**:
  - `uint32_t des_sboxes_lookup(uint64_t in_48)`:
    Maps 48 bits to 32 bits across 8 S-Boxes. Each 6-bit input extracts outer bits for row (0..3) and middle 4 bits for column (0..15).
  - `uint32_t des_round_function_f(uint32_t right_half, uint64_t round_key)`:
    Connects Expansion $E$, XOR with subkey, S-Box substitution, and Permutation $P$.

---

## Verification
- Cross-checked with reference vectors and statistical avalanche tests (demonstrating ~49% output bit flip per single input bit change).
