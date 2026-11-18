`timescale 1ns/1ps

/*
 * Module: des_core
 * Author: Saeed
 * Contribution: Top-Level DES Core & 16-Round Feistel Network assembly,
 *               subkey order inversion for decryption, and pre-output swap {R16, L16}.
 *
 * Team Members & Contributions:
 *   - Zeyad: Permutation Layer (IP, IP^-1, Expansion E, Permutation P)
 *   - Lotfy: Key Schedule (PC-1, circular shifts, PC-2, subkeys K1..K16)
 *   - Marcelino (Marc): Non-linear S-Boxes (S1..S8) and Round Function F(R, K)
 *   - Saeed: Feistel Round, Top-Level DES Core, and Encrypt/Decrypt Integration
 *   - Mohamed: System Testbenches and Verification Suite (tb_des, tb_des_comprehensive)
 */

module des_core (
    input  wire [63:0] data_in,
    input  wire [63:0] key,
    input  wire        decrypt,    // 0: Encrypt, 1: Decrypt
    output wire [63:0] data_out
);

    // 1. Generate Subkeys K1..K16 using Lotfy's key schedule
    wire [47:0] k[1:16];

    des_key_schedule u_key_sched (
        .key_in (key),
        .k1     (k[1]),  .k2  (k[2]),  .k3  (k[3]),  .k4  (k[4]),
        .k5     (k[5]),  .k6  (k[6]),  .k7  (k[7]),  .k8  (k[8]),
        .k9     (k[9]),  .k10 (k[10]), .k11 (k[11]), .k12 (k[12]),
        .k13    (k[13]), .k14 (k[14]), .k15 (k[15]), .k16 (k[16])
    );

    // 2. Select subkey order: normal for encryption, reversed for decryption
    wire [47:0] rk [1:16];
    assign rk[1]  = decrypt ? k[16] : k[1];
    assign rk[2]  = decrypt ? k[15] : k[2];
    assign rk[3]  = decrypt ? k[14] : k[3];
    assign rk[4]  = decrypt ? k[13] : k[4];
    assign rk[5]  = decrypt ? k[12] : k[5];
    assign rk[6]  = decrypt ? k[11] : k[6];
    assign rk[7]  = decrypt ? k[10] : k[7];
    assign rk[8]  = decrypt ? k[9]  : k[8];
    assign rk[9]  = decrypt ? k[8]  : k[9];
    assign rk[10] = decrypt ? k[7]  : k[10];
    assign rk[11] = decrypt ? k[6]  : k[11];
    assign rk[12] = decrypt ? k[5]  : k[12];
    assign rk[13] = decrypt ? k[4]  : k[13];
    assign rk[14] = decrypt ? k[3]  : k[14];
    assign rk[15] = decrypt ? k[2]  : k[15];
    assign rk[16] = decrypt ? k[1]  : k[16];

    // 3. Initial Permutation (IP) using Zeyad's module
    wire [63:0] ip_data;
    des_initial_permutation u_ip (
        .in_block  (data_in),
        .out_block (ip_data)
    );

    // 4. 16 Feistel Rounds
    wire [31:0] l [0:16];
    wire [31:0] r [0:16];

    assign l[0] = ip_data[63:32];
    assign r[0] = ip_data[31:0];

    genvar i;
    generate
        for (i = 1; i <= 16; i = i + 1) begin : gen_rounds
            des_feistel_round u_round (
                .l_in   (l[i-1]),
                .r_in   (r[i-1]),
                .subkey (rk[i]),
                .l_out  (l[i]),
                .r_out  (r[i])
            );
        end
    endgenerate

    // 5. Final Swap: {R[16], L[16]}
    wire [63:0] pre_output = {r[16], l[16]};

    // 6. Inverse Initial Permutation (IP^-1) using Zeyad's module
    des_inverse_initial_permutation u_inv_ip (
        .in_block  (pre_output),
        .out_block (data_out)
    );

endmodule
