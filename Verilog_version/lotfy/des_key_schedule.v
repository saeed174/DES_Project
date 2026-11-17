`timescale 1ns/1ps

module des_key_schedule (
    input  wire [63:0] key_in,
    output wire [47:0] k1,
    output wire [47:0] k2,
    output wire [47:0] k3,
    output wire [47:0] k4,
    output wire [47:0] k5,
    output wire [47:0] k6,
    output wire [47:0] k7,
    output wire [47:0] k8,
    output wire [47:0] k9,
    output wire [47:0] k10,
    output wire [47:0] k11,
    output wire [47:0] k12,
    output wire [47:0] k13,
    output wire [47:0] k14,
    output wire [47:0] k15,
    output wire [47:0] k16
);

    wire [27:0] c0, d0;
    des_pc1 u_pc1 (
        .key_in (key_in),
        .c_out  (c0),
        .d_out  (d0)
    );

    wire [27:0] c [1:16];
    wire [27:0] d [1:16];

    // Round 1 (shift 1)
    assign c[1] = {c0[26:0], c0[27]};
    assign d[1] = {d0[26:0], d0[27]};

    // Round 2 (shift 1)
    assign c[2] = {c[1][26:0], c[1][27]};
    assign d[2] = {d[1][26:0], d[1][27]};

    // Round 3 (shift 2)
    assign c[3] = {c[2][25:0], c[2][27:26]};
    assign d[3] = {d[2][25:0], d[2][27:26]};

    // Round 4 (shift 2)
    assign c[4] = {c[3][25:0], c[3][27:26]};
    assign d[4] = {d[3][25:0], d[3][27:26]};

    // Round 5 (shift 2)
    assign c[5] = {c[4][25:0], c[4][27:26]};
    assign d[5] = {d[4][25:0], d[4][27:26]};

    // Round 6 (shift 2)
    assign c[6] = {c[5][25:0], c[5][27:26]};
    assign d[6] = {d[5][25:0], d[5][27:26]};

    // Round 7 (shift 2)
    assign c[7] = {c[6][25:0], c[6][27:26]};
    assign d[7] = {d[6][25:0], d[6][27:26]};

    // Round 8 (shift 2)
    assign c[8] = {c[7][25:0], c[7][27:26]};
    assign d[8] = {d[7][25:0], d[7][27:26]};

    // Round 9 (shift 1)
    assign c[9] = {c[8][26:0], c[8][27]};
    assign d[9] = {d[8][26:0], d[8][27]};

    // Round 10 (shift 2)
    assign c[10] = {c[9][25:0], c[9][27:26]};
    assign d[10] = {d[9][25:0], d[9][27:26]};

    // Round 11 (shift 2)
    assign c[11] = {c[10][25:0], c[10][27:26]};
    assign d[11] = {d[10][25:0], d[10][27:26]};

    // Round 12 (shift 2)
    assign c[12] = {c[11][25:0], c[11][27:26]};
    assign d[12] = {d[11][25:0], d[11][27:26]};

    // Round 13 (shift 2)
    assign c[13] = {c[12][25:0], c[12][27:26]};
    assign d[13] = {d[12][25:0], d[12][27:26]};

    // Round 14 (shift 2)
    assign c[14] = {c[13][25:0], c[13][27:26]};
    assign d[14] = {d[13][25:0], d[13][27:26]};

    // Round 15 (shift 2)
    assign c[15] = {c[14][25:0], c[14][27:26]};
    assign d[15] = {d[14][25:0], d[14][27:26]};

    // Round 16 (shift 1)
    assign c[16] = {c[15][26:0], c[15][27]};
    assign d[16] = {d[15][26:0], d[15][27]};

    // Generate PC-2 for all 16 rounds
    des_pc2 u_pc2_1  (.c_in(c[1]),  .d_in(d[1]),  .subkey_out(k1));
    des_pc2 u_pc2_2  (.c_in(c[2]),  .d_in(d[2]),  .subkey_out(k2));
    des_pc2 u_pc2_3  (.c_in(c[3]),  .d_in(d[3]),  .subkey_out(k3));
    des_pc2 u_pc2_4  (.c_in(c[4]),  .d_in(d[4]),  .subkey_out(k4));
    des_pc2 u_pc2_5  (.c_in(c[5]),  .d_in(d[5]),  .subkey_out(k5));
    des_pc2 u_pc2_6  (.c_in(c[6]),  .d_in(d[6]),  .subkey_out(k6));
    des_pc2 u_pc2_7  (.c_in(c[7]),  .d_in(d[7]),  .subkey_out(k7));
    des_pc2 u_pc2_8  (.c_in(c[8]),  .d_in(d[8]),  .subkey_out(k8));
    des_pc2 u_pc2_9  (.c_in(c[9]),  .d_in(d[9]),  .subkey_out(k9));
    des_pc2 u_pc2_10 (.c_in(c[10]), .d_in(d[10]), .subkey_out(k10));
    des_pc2 u_pc2_11 (.c_in(c[11]), .d_in(d[11]), .subkey_out(k11));
    des_pc2 u_pc2_12 (.c_in(c[12]), .d_in(d[12]), .subkey_out(k12));
    des_pc2 u_pc2_13 (.c_in(c[13]), .d_in(d[13]), .subkey_out(k13));
    des_pc2 u_pc2_14 (.c_in(c[14]), .d_in(d[14]), .subkey_out(k14));
    des_pc2 u_pc2_15 (.c_in(c[15]), .d_in(d[15]), .subkey_out(k15));
    des_pc2 u_pc2_16 (.c_in(c[16]), .d_in(d[16]), .subkey_out(k16));

endmodule
