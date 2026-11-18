`timescale 1ns/1ps

/*
 * Module: des_feistel_round
 * Author: Saeed
 * Contribution: DES Core & Feistel Network — Implements a single DES Feistel round
 *               (L_out = R_in, R_out = L_in ^ F(R_in, subkey)) using Marcelino's F module.
 */

module des_feistel_round (
    input  wire [31:0] l_in,
    input  wire [31:0] r_in,
    input  wire [47:0] subkey,
    output wire [31:0] l_out,
    output wire [31:0] r_out
);

    wire [31:0] f_result;

    // F(R, K)
    des_round_function_f u_f (
        .r_in      (r_in),
        .round_key (subkey),
        .f_out     (f_result)
    );

    assign l_out = r_in;
    assign r_out = l_in ^ f_result;

endmodule
