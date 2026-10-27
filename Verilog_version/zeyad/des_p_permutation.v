`timescale 1ns/1ps

module des_p_permutation (
    input  wire [31:0] in_p,
    output wire [31:0] out_p
);

    assign out_p = {
        // Row 1 (bits 31..28)
        in_p[32-16], in_p[32-7],  in_p[32-20], in_p[32-21],
        // Row 2 (bits 27..24)
        in_p[32-29], in_p[32-12], in_p[32-28], in_p[32-17],
        // Row 3 (bits 23..20)
        in_p[32-1],  in_p[32-15], in_p[32-23], in_p[32-26],
        // Row 4 (bits 19..16)
        in_p[32-5],  in_p[32-18], in_p[32-31], in_p[32-10],
        // Row 5 (bits 15..12)
        in_p[32-2],  in_p[32-8],  in_p[32-24], in_p[32-14],
        // Row 6 (bits 11..8)
        in_p[32-32], in_p[32-27], in_p[32-3],  in_p[32-9],
        // Row 7 (bits 7..4)
        in_p[32-19], in_p[32-13], in_p[32-30], in_p[32-6],
        // Row 8 (bits 3..0)
        in_p[32-22], in_p[32-11], in_p[32-4],  in_p[32-25]
    };

endmodule
