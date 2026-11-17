`timescale 1ns/1ps

module des_pc1 (
    input  wire [63:0] key_in,
    output wire [27:0] c_out,
    output wire [27:0] d_out
);

    // C0 (28 bits):
    assign c_out = {
        key_in[64-57], key_in[64-49], key_in[64-41], key_in[64-33], key_in[64-25], key_in[64-17], key_in[64-9],
        key_in[64-1],  key_in[64-58], key_in[64-50], key_in[64-42], key_in[64-34], key_in[64-26], key_in[64-18],
        key_in[64-10], key_in[64-2],  key_in[64-59], key_in[64-51], key_in[64-43], key_in[64-35], key_in[64-27],
        key_in[64-19], key_in[64-11], key_in[64-3],  key_in[64-60], key_in[64-52], key_in[64-44], key_in[64-36]
    };

    // D0 (28 bits):
    assign d_out = {
        key_in[64-63], key_in[64-55], key_in[64-47], key_in[64-39], key_in[64-31], key_in[64-23], key_in[64-15],
        key_in[64-7],  key_in[64-62], key_in[64-54], key_in[64-46], key_in[64-38], key_in[64-30], key_in[64-22],
        key_in[64-14], key_in[64-6],  key_in[64-61], key_in[64-53], key_in[64-45], key_in[64-37], key_in[64-29],
        key_in[64-21], key_in[64-13], key_in[64-5],  key_in[64-28], key_in[64-20], key_in[64-12], key_in[64-4]
    };

endmodule
