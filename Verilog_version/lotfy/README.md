# Key Schedule & Round Subkeys — Lotfy

## Overview & Role
**Owner:** Lotfy  
**Responsibility:** Derivation of the sixteen 48-bit round subkeys ($K_1 \dots K_{16}$) from the 64-bit original key.

---

## Algorithm Steps
1. **Permuted Choice 1 (PC-1):**
   - Discards 8 parity bits (8, 16, 24, 32, 40, 48, 56, 64).
   - Permutes the remaining 56 bits into two 28-bit halves: $C_0$ and $D_0$.
2. **Circular Left Shifts:**
   - Rounds 1, 2, 9, and 16 rotate by **1 bit**.
   - All other 12 rounds rotate by **2 bits**.
3. **Permuted Choice 2 (PC-2):**
   - Compresses each 56-bit pair $\{C_i, D_i\}$ into a 48-bit round subkey $K_i$.

---

## Deliverables & Modules

### 1. Verilog Implementation (`Verilog_version/lotfy/`)
- **`des_pc1.v`**
  - Module: `des_pc1`
  - Input: `key_in [63:0]`
  - Outputs: `c_out [27:0]`, `d_out [27:0]`
- **`des_pc2.v`**
  - Module: `des_pc2`
  - Inputs: `c_in [27:0]`, `d_in [27:0]`
  - Output: `subkey_out [47:0]`
- **`des_key_schedule.v`**
  - Module: `des_key_schedule`
  - Top key scheduler module that outputs all 16 subkeys `k1..k16` concurrently to the Feistel core.

### 2. C Implementation (`c_version/lotfy/`)
- **`des_key_schedule.h`**:
  `void des_generate_subkeys(uint64_t key, uint64_t subkeys[16]);`
- **`des_key_schedule.c`**:
  Implements PC-1, 28-bit rotation helper `left_rot_28()`, shift schedule, and PC-2.

---

## Acceptance Criteria
- Exactly 16 subkeys are generated.
- Each subkey is precisely 48 bits wide.
- In decryption mode, subkeys are consumed in reverse order ($K_{16} \dots K_1$).
