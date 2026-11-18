# Permutation Layer — Zeyad

## Overview & Role
**Owner:** Zeyad  
**Responsibility:** Bit-reordering permutations across the DES data path in C.

---

## Files & Functions

- **`des_permutation.h`**:
  Contains function declarations and documentation for external module integration.
- **`des_permutation.c`**:
  - `uint64_t des_initial_permutation(uint64_t in_block)`: Standard DES 64-bit Initial Permutation ($IP$).
  - `uint64_t des_inverse_initial_permutation(uint64_t in_block)`: Final Permutation ($IP^{-1}$).
  - `uint64_t des_expansion_permutation(uint32_t in_r)`: Expands 32-bit Right-half $R$ into 48 bits.
  - `uint32_t des_p_permutation(uint32_t in_p)`: Permutes 32-bit S-Box output.

---

## Verification
- Validated with mathematical identity $IP^{-1}(IP(X)) = X$ across 50 random 64-bit blocks.
- Passes all standard NIST test vectors when integrated with the core.
