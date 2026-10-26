# DES Core & Feistel Network — Saeed

## Overview & Role
**Owner:** Saeed  
**Responsibility:** Assembly and integration of the 16-round Feistel network data path and top-level encryption/decryption control.

---

## Feistel Round Equations
For round $i = 1 \dots 16$:
$$L_i = R_{i-1}$$
$$R_i = L_{i-1} \oplus F(R_{i-1}, K_i)$$

After round 16:
$$\text{Pre-output Block} = \{R_{16}, L_{16}\}$$
$$\text{Ciphertext} = IP^{-1}(\{R_{16}, L_{16}\})$$

### Decryption Control:
The Feistel network is symmetric; decryption uses identical round computations with the round keys reversed:
- **Encrypt (`decrypt == 0`):** Uses $K_1, K_2, \dots, K_{16}$.
- **Decrypt (`decrypt == 1`):** Uses $K_{16}, K_{15}, \dots, K_1$.

---

## Deliverables & Modules

### 1. Verilog Implementation (`Verilog_version/saeed/`)
- **`des_feistel_round.v`**
  - Module: `des_feistel_round`
  - Inputs: `l_in [31:0]`, `r_in [31:0]`, `subkey [47:0]`
  - Outputs: `l_out [31:0]`, `r_out [31:0]`
  - Computes a single Feistel round using Marc's $F(R, K)$.
- **`des_core.v`**
  - Module: `des_core`
  - Inputs: `data_in [63:0]`, `key [63:0]`, `decrypt` (1 bit)
  - Output: `data_out [63:0]`
  - Top-level datapath connecting Lotfy's key scheduler, Zeyad's $IP$, 16 Feistel rounds generated via loop, pre-output swap, and Zeyad's $IP^{-1}$.

### 2. C Implementation (`c_version/saeed/`)
- **`des_core.h`**:
  - `uint64_t des_encrypt_block(uint64_t block, uint64_t key);`
  - `uint64_t des_decrypt_block(uint64_t block, uint64_t key);`
- **`des_core.c`**:
  Implements `des_process_block()` with subkey generation, $IP$, 16 Feistel rounds, pre-output block swap, and $IP^{-1}$.
