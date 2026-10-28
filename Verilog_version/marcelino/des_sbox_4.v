`timescale 1ns/1ps

module des_sbox_4 (
    input  wire [5:0] in_bits,
    output reg  [3:0] out_bits
);
    wire [1:0] row = {in_bits[5], in_bits[0]};
    wire [3:0] col = in_bits[4:1];

    always @(*) begin
        case (row)
            2'd0: case (col)
                4'd0:  out_bits = 4'd7;  4'd1:  out_bits = 4'd13; 4'd2:  out_bits = 4'd14; 4'd3:  out_bits = 4'd3;
                4'd4:  out_bits = 4'd0;  4'd5:  out_bits = 4'd6;  4'd6:  out_bits = 4'd9;  4'd7:  out_bits = 4'd10;
                4'd8:  out_bits = 4'd1;  4'd9:  out_bits = 4'd2;  4'd10: out_bits = 4'd8;  4'd11: out_bits = 4'd5;
                4'd12: out_bits = 4'd11; 4'd13: out_bits = 4'd12; 4'd14: out_bits = 4'd4;  4'd15: out_bits = 4'd15;
            endcase
            2'd1: case (col)
                4'd0:  out_bits = 4'd13; 4'd1:  out_bits = 4'd8;  4'd2:  out_bits = 4'd11; 4'd3:  out_bits = 4'd5;
                4'd4:  out_bits = 4'd6;  4'd5:  out_bits = 4'd15; 4'd6:  out_bits = 4'd0;  4'd7:  out_bits = 4'd3;
                4'd8:  out_bits = 4'd4;  4'd9:  out_bits = 4'd7;  4'd10: out_bits = 4'd2;  4'd11: out_bits = 4'd12;
                4'd12: out_bits = 4'd1;  4'd13: out_bits = 4'd10; 4'd14: out_bits = 4'd14; 4'd15: out_bits = 4'd9;
            endcase
            2'd2: case (col)
                4'd0:  out_bits = 4'd10; 4'd1:  out_bits = 4'd6;  4'd2:  out_bits = 4'd9;  4'd3:  out_bits = 4'd0;
                4'd4:  out_bits = 4'd12; 4'd5:  out_bits = 4'd11; 4'd6:  out_bits = 4'd7;  4'd7:  out_bits = 4'd13;
                4'd8:  out_bits = 4'd15; 4'd9:  out_bits = 4'd1;  4'd10: out_bits = 4'd3;  4'd11: out_bits = 4'd14;
                4'd12: out_bits = 4'd5;  4'd13: out_bits = 4'd2;  4'd14: out_bits = 4'd8;  4'd15: out_bits = 4'd4;
            endcase
            2'd3: case (col)
                4'd0:  out_bits = 4'd3;  4'd1:  out_bits = 4'd15; 4'd2:  out_bits = 4'd0;  4'd3:  out_bits = 4'd6;
                4'd4:  out_bits = 4'd10; 4'd5:  out_bits = 4'd1;  4'd6:  out_bits = 4'd13; 4'd7:  out_bits = 4'd8;
                4'd8:  out_bits = 4'd9;  4'd9:  out_bits = 4'd4;  4'd10: out_bits = 4'd5;  4'd11: out_bits = 4'd11;
                4'd12: out_bits = 4'd12; 4'd13: out_bits = 4'd7;  4'd14: out_bits = 4'd2;  4'd15: out_bits = 4'd14;
            endcase
        endcase
    end
endmodule
