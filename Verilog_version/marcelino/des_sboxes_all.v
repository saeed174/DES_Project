`timescale 1ns/1ps

module des_sboxes_all (
    input  wire [47:0] in_48,
    output wire [31:0] out_32
);

    des_sbox_1 u_s1 (.in_bits(in_48[47:42]), .out_bits(out_32[31:28]));
    des_sbox_2 u_s2 (.in_bits(in_48[41:36]), .out_bits(out_32[27:24]));
    des_sbox_3 u_s3 (.in_bits(in_48[35:30]), .out_bits(out_32[23:20]));
    des_sbox_4 u_s4 (.in_bits(in_48[29:24]), .out_bits(out_32[19:16]));
    des_sbox_5 u_s5 (.in_bits(in_48[23:18]), .out_bits(out_32[15:12]));
    des_sbox_6 u_s6 (.in_bits(in_48[17:12]), .out_bits(out_32[11:8]));
    des_sbox_7 u_s7 (.in_bits(in_48[11:6]),  .out_bits(out_32[7:4]));
    des_sbox_8 u_s8 (.in_bits(in_48[5:0]),   .out_bits(out_32[3:0]));

endmodule
