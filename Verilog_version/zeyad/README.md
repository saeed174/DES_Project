# Permutation Layer — Zeyad

## Overview & Role
**Owner:** Zeyad  
**Responsibility:** Bit-reordering permutations across the DES data path in both **Verilog (RTL)** and **C**.

DES tables use standard 1-based indexing from the most significant bit (MSB):
- For a 64-bit input $X$, table entry $k$ maps to $X[64 - k]$.
- For a 32-bit input $R$, table entry $k$ maps to $R[32 - k]$.

---

## Deliverables & Modules

### 1. Verilog Implementation (`Verilog_version/zeyad/`)
- **`des_initial_permutation.v`**
  - Module: `des_initial_permutation`
  - Input: `in_block [63:0]`
  - Output: `out_block [63:0]`
  - Standard DES 64-bit Initial Permutation ($IP$).
- **`des_inverse_initial_permutation.v`**
  - Module: `des_inverse_initial_permutation`
  - Input: `in_block [63:0]`
  - Output: `out_block [63:0]`
  - Standard DES 64-bit Final Permutation ($IP^{-1}$).
- **`des_expansion_permutation.v`**
  - Module: `des_expansion_permutation`
  - Input: `in_r [31:0]`
  - Output: `out_e [47:0]`
  - Expands 32-bit Right-half $R$ into 48 bits for the round key XOR.
- **`des_p_permutation.v`**
  - Module: `des_p_permutation`
  - Input: `in_p [31:0]`
  - Output: `out_p [31:0]`
  - Permutes the 32-bit concatenated S-Box outputs to produce $F(R, K)$.

### 2. C Implementation (`c_version/zeyad/`)
- **`des_permutation.h`**: Function prototypes.
- **`des_permutation.c`**:
  - `uint64_t des_initial_permutation(uint64_t in_block);`
  - `uint64_t des_inverse_initial_permutation(uint64_t in_block);`
  - `uint64_t des_expansion_permutation(uint32_t in_r);`
  - `uint32_t des_p_permutation(uint32_t in_p);`

---

## Mathematical Verification & Acceptance
- **Inversion Property:** $IP^{-1}(IP(X)) \equiv X$ for all 64-bit inputs. Verified in both RTL and C across random inputs.
- **Width Integrity:** All output widths strictly conform to DES specifications (64, 48, and 32 bits).
