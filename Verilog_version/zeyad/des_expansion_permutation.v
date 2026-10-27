`timescale 1ns/1ps

module des_expansion_permutation (
    input  wire [31:0] in_r,
    output wire [47:0] out_e
);

    assign out_e = {
        // Block 1 (bits 47..42)
        in_r[32-32], in_r[32-1],  in_r[32-2],  in_r[32-3],  in_r[32-4],  in_r[32-5],
        // Block 2 (bits 41..36)
        in_r[32-4],  in_r[32-5],  in_r[32-6],  in_r[32-7],  in_r[32-8],  in_r[32-9],
        // Block 3 (bits 35..30)
        in_r[32-8],  in_r[32-9],  in_r[32-10], in_r[32-11], in_r[32-12], in_r[32-13],
        // Block 4 (bits 29..24)
        in_r[32-12], in_r[32-13], in_r[32-14], in_r[32-15], in_r[32-16], in_r[32-17],
        // Block 5 (bits 23..18)
        in_r[32-16], in_r[32-17], in_r[32-18], in_r[32-19], in_r[32-20], in_r[32-21],
        // Block 6 (bits 17..12)
        in_r[32-20], in_r[32-21], in_r[32-22], in_r[32-23], in_r[32-24], in_r[32-25],
        // Block 7 (bits 11..6)
        in_r[32-24], in_r[32-25], in_r[32-26], in_r[32-27], in_r[32-28], in_r[32-29],
        // Block 8 (bits 5..0)
        in_r[32-28], in_r[32-29], in_r[32-30], in_r[32-31], in_r[32-32], in_r[32-1]
    };

endmodule
