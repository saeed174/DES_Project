`timescale 1ns/1ps

module des_initial_permutation (
    input  wire [63:0] in_block,
    output wire [63:0] out_block
);

    assign out_block = {
        // Row 1 (bits 63..56)
        in_block[64-58], in_block[64-50], in_block[64-42], in_block[64-34],
        in_block[64-26], in_block[64-18], in_block[64-10], in_block[64-2],
        // Row 2 (bits 55..48)
        in_block[64-60], in_block[64-52], in_block[64-44], in_block[64-36],
        in_block[64-28], in_block[64-20], in_block[64-12], in_block[64-4],
        // Row 3 (bits 47..40)
        in_block[64-62], in_block[64-54], in_block[64-46], in_block[64-38],
        in_block[64-30], in_block[64-22], in_block[64-14], in_block[64-6],
        // Row 4 (bits 39..32)
        in_block[64-64], in_block[64-56], in_block[64-48], in_block[64-40],
        in_block[64-32], in_block[64-24], in_block[64-16], in_block[64-8],
        // Row 5 (bits 31..24)
        in_block[64-57], in_block[64-49], in_block[64-41], in_block[64-33],
        in_block[64-25], in_block[64-17], in_block[64-9],  in_block[64-1],
        // Row 6 (bits 23..16)
        in_block[64-59], in_block[64-51], in_block[64-43], in_block[64-35],
        in_block[64-27], in_block[64-19], in_block[64-11], in_block[64-3],
        // Row 7 (bits 15..8)
        in_block[64-61], in_block[64-53], in_block[64-45], in_block[64-37],
        in_block[64-29], in_block[64-21], in_block[64-13], in_block[64-5],
        // Row 8 (bits 7..0)
        in_block[64-63], in_block[64-55], in_block[64-47], in_block[64-39],
        in_block[64-31], in_block[64-23], in_block[64-15], in_block[64-7]
    };

endmodule
