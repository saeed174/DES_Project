# S-Boxes & Round Function F — Marc

## Overview & Role
**Owner:** Marc  
**Responsibility:** Implementation of the non-linear DES S-Box substitution layer and the complete Round Function $F(R, K)$.

---

## Round Function Architecture
For a 32-bit input $R$ and 48-bit round subkey $K$:
1. **Expansion ($E$):** 32-bit $R \rightarrow$ 48 bits (calls Zeyad's module).
2. **Key Mixing:** $48\text{-bit expanded } R \oplus 48\text{-bit } K$.
3. **S-Box Substitution ($S_1 \dots S_8$):**
   - 48 bits are divided into eight 6-bit blocks: $B_1 \dots B_8$.
   - For each 6-bit input $b = (b_5, b_4, b_3, b_2, b_1, b_0)$:
     - **Row index:** $\{b_5, b_0\}$ (2 bits, range 0..3).
     - **Column index:** $\{b_4, b_3, b_2, b_1\}$ (4 bits, range 0..15).
   - Each S-Box outputs 4 bits $\rightarrow$ Eight 4-bit outputs produce 32 bits.
4. **Permutation ($P$):** Permutes 32 bits to produce the final $F(R, K)$ output (calls Zeyad's module).

---

## Deliverables & Modules

### 1. Verilog Implementation (`Verilog_version/marc/`)
- **`des_sbox_1.v`** through **`des_sbox_8.v`**
  - Modules: `des_sbox_1` .. `des_sbox_8`
  - Input: `in_bits [5:0]`
  - Output: `out_bits [3:0]`
- **`des_sboxes_all.v`**
  - Module: `des_sboxes_all`
  - Concatenates $S_1 \dots S_8$ (`in_48 [47:0]` $\rightarrow$ `out_32 [31:0]`).
- **`des_round_function_f.v`**
  - Module: `des_round_function_f`
  - Inputs: `r_in [31:0]`, `round_key [47:0]`
  - Output: `f_out [31:0]`

### 2. C Implementation (`c_version/marc/`)
- **`des_round_function.h`**:
  - `uint32_t des_sboxes_lookup(uint64_t in_48);`
  - `uint32_t des_round_function_f(uint32_t right_half, uint64_t round_key);`
- **`des_round_function.c`**:
  Table-driven 3D array lookup `SBOX[8][4][16]` implementing all eight substitution boxes.
