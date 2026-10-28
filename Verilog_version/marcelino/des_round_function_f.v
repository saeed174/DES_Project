`timescale 1ns/1ps

module des_round_function_f (
    input  wire [31:0] r_in,
    input  wire [47:0] round_key,
    output wire [31:0] f_out
);

    wire [47:0] e_expanded;
    wire [47:0] xor_key;
    wire [31:0] sbox_out;

    // 1. Expand 32-bit R to 48 bits
    des_expansion_permutation u_exp (
        .in_r  (r_in),
        .out_e (e_expanded)
    );

    // 2. XOR with Round Subkey
    assign xor_key = e_expanded ^ round_key;

    // 3. 8 S-Boxes substitution (48 bits -> 32 bits)
    des_sboxes_all u_sboxes (
        .in_48  (xor_key),
        .out_32 (sbox_out)
    );

    // 4. Permutation P (32 bits -> 32 bits)
    des_p_permutation u_p (
        .in_p  (sbox_out),
        .out_p (f_out)
    );

endmodule
