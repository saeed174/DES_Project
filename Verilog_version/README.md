# DES Verilog RTL Implementation — Simulation & Usage Guide

This folder contains the **Verilog RTL implementation** of the Data Encryption Standard (DES, FIPS PUB 46-3), including:
- Purely combinational 16-round DES core (`des_core/des_core.v`)
- Modular submodules (`permutation/`, `key_schedule/`, `round_function/`, `des_core/`)
- Basic and comprehensive verification testbenches (`testbenches/tb_des.v`, `testbenches/tb_des_comprehensive.v`)

---

## 📍 Where to Run Commands

Open a terminal (or the QuestaSim/ModelSim Transcript console) and navigate into the **`Verilog_version/`** directory inside the repository:

```bash
cd DES_Project/Verilog_version
```

> **Note:** All relative paths below (`permutation/*.v`, `key_schedule/*.v`, `round_function/*.v`, `des_core/*.v`, `testbenches/...`) assume your working directory is **`Verilog_version/`**.

---

## 📁 Folder Layout & Dependency Order

```text
Verilog_version/
├── permutation/                             # 1. Permutation layer (Verilog-2001) — Zeyad
│   ├── des_initial_permutation.v
│   ├── des_inverse_initial_permutation.v
│   ├── des_expansion_permutation.v
│   ├── des_p_permutation.v
│   └── README.md
├── key_schedule/                            # 2. Key schedule (Verilog-2001) — Lotfy
│   ├── des_pc1.v
│   ├── des_pc2.v
│   ├── des_key_schedule.v
│   └── README.md
├── round_function/                          # 3. S-Boxes & Round Function F (Verilog-2001) — Marcelino (Marc)
│   ├── des_sbox_1.v ... des_sbox_8.v
│   ├── des_sboxes_all.v
│   ├── des_round_function_f.v
│   └── README.md
├── des_core/                                # 4. Feistel round & Top-level core (Verilog-2001) — Saeed
│   ├── des_feistel_round.v
│   ├── des_core.v                           # Top-level DUT module: des_core
│   └── README.md
└── testbenches/                             # 5. Simulation testbenches — Mohamed
    ├── tb_des.v                             # Basic 5-testbench (Verilog-2001)
    ├── tb_des_comprehensive.v               # Full 130-check suite (uses SystemVerilog)
    └── README.md
```

---

## 🛠️ Prerequisites

- **Recommended:** **QuestaSim / ModelSim** (`vlib`, `vlog`, `vsim`) — required for full support of `tb_des_comprehensive.v`.
- **Alternative (Basic Testbench):** **Icarus Verilog** (`iverilog`, `vvp`) — works out of the box for `tb_des.v` and all RTL modules.

> **Important Compilation Flag Note:**
> All RTL modules and `testbenches/tb_des.v` are standard **Verilog-2001**.
> However, `testbenches/tb_des_comprehensive.v` uses SystemVerilog features (`input string test_name` and `$countones(...)`), so compile it with **`-sv`** in QuestaSim/ModelSim (`vlog -sv ...`).

---

## 🚀 How to Run Simulation (QuestaSim / ModelSim)

### Option A: Terminal / Batch Mode (Fastest)

From **`Verilog_version/`**:

1. **Create the `work` library and compile all modules & testbenches:**
   ```bash
   vlib work
   vlog -sv permutation/*.v key_schedule/*.v round_function/*.v des_core/*.v testbenches/tb_des.v testbenches/tb_des_comprehensive.v
   ```

2. **Run the Comprehensive Testbench (130 checks across 5 sections):**
   ```bash
   vsim -c work.tb_des_comprehensive -do "run -all; quit -f"
   ```

3. **Or run the Basic Unit Testbench (5 checks):**
   ```bash
   vsim -c work.tb_des -do "run -all; quit -f"
   ```

---

### Option B: QuestaSim / ModelSim GUI (With Waveforms)

1. Open **QuestaSim** or **ModelSim**.
2. Change directory to **`DES_Project/Verilog_version`** (`File -> Change Directory...`, or in the Transcript window run `cd "<path-to>/DES_Project/Verilog_version"`).
3. Run the following commands in the **Transcript** window:
   ```tcl
   vlib work
   vlog -sv permutation/*.v key_schedule/*.v round_function/*.v des_core/*.v testbenches/tb_des_comprehensive.v
   vsim -voptargs="+acc" work.tb_des_comprehensive
   add wave -r /*
   run -all
   wave zoom full
   ```
   - `-voptargs="+acc"` keeps internal signals visible for waveform inspection.
   - Replace `tb_des_comprehensive` with `tb_des` if you want to inspect the 5-test basic testbench instead.

---

## 🚀 How to Run Simulation (Icarus Verilog)

From **`Verilog_version/`**, you can run the basic Verilog-2001 testbench (`tb_des.v`) with `iverilog` and `vvp`:

```bash
iverilog -o tb_des.vvp permutation/*.v key_schedule/*.v round_function/*.v des_core/*.v testbenches/tb_des.v
vvp tb_des.vvp
```

> **Note:** `testbenches/tb_des_comprehensive.v` uses SystemVerilog `string` task arguments and `$countones()`, which may not compile or run cleanly depending on your `iverilog` version even with `-g2012`. Use QuestaSim/ModelSim with `vlog -sv` for the comprehensive suite.

---

## 🧪 What Each Testbench Verifies

| Testbench | Scope | Checks |
| :--- | :--- | :--- |
| **`testbenches/tb_des.v`** | Basic sanity check: $IP^{-1}(IP(X))$ loopback, Assignment KAT encrypt/decrypt, NIST all-zero KAT encrypt/decrypt. | 5 checks |
| **`testbenches/tb_des_comprehensive.v`** | Section 1: 16 random $IP^{-1}(IP(X))$ checks<br>Section 2: 6 NIST/project KAT vectors (encrypt + decrypt)<br>Section 3: Complementarity $\text{DES}(\sim K, \sim P) = \sim\text{DES}(K, P)$<br>Section 4: 64-bit single-flip Avalanche diffusion check<br>Section 5: 100 random encrypt/decrypt roundtrips | 130 checks |

---

## 🧩 Top-Level Hardware Interface (`des_core`)

To instantiate the DES core in your own RTL design or synthesis flow, use `des_core` in [`des_core/des_core.v`](./des_core/des_core.v) and include all `.v` files under `permutation/`, `key_schedule/`, `round_function/`, and `des_core/` (excluding `testbenches/`):

```verilog
des_core u_des (
    .data_in  (data_in),   // [63:0] 64-bit plaintext (encrypt) or ciphertext (decrypt)
    .key      (key),       // [63:0] 64-bit DES key
    .decrypt  (decrypt),   // 1'b0 = Encrypt, 1'b1 = Decrypt
    .data_out (data_out)   // [63:0] 64-bit output block (combinational)
);
```
