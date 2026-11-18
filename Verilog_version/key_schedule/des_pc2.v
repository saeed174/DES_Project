`timescale 1ns/1ps

/*
 * Module: des_pc2
 * Author: Lotfy
 * Contribution: Key Schedule — Implements Permuted Choice 2 (PC-2), compressing {C, D} into a 48-bit subkey.
 */

module des_pc2 (
    input  wire [27:0] c_in,
    input  wire [27:0] d_in,
    output wire [47:0] subkey_out
);

    wire [55:0] cd = {c_in, d_in};

    assign subkey_out = {
        // Row 1
        cd[56-14], cd[56-17], cd[56-11], cd[56-24], cd[56-1],  cd[56-5],
        // Row 2
        cd[56-3],  cd[56-28], cd[56-15], cd[56-6],  cd[56-21], cd[56-10],
        // Row 3
        cd[56-23], cd[56-19], cd[56-12], cd[56-4],  cd[56-26], cd[56-8],
        // Row 4
        cd[56-16], cd[56-7],  cd[56-27], cd[56-20], cd[56-13], cd[56-2],
        // Row 5
        cd[56-41], cd[56-52], cd[56-31], cd[56-37], cd[56-47], cd[56-55],
        // Row 6
        cd[56-30], cd[56-40], cd[56-51], cd[56-45], cd[56-33], cd[56-48],
        // Row 7
        cd[56-44], cd[56-49], cd[56-39], cd[56-56], cd[56-34], cd[56-53],
        // Row 8
        cd[56-46], cd[56-42], cd[56-50], cd[56-36], cd[56-29], cd[56-32]
    };

endmodule
