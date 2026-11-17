`timescale 1ns/1ps

module tb_des;

    reg  [63:0] tb_data_in;
    reg  [63:0] tb_key;
    reg         tb_decrypt;
    wire [63:0] tb_data_out;

    integer pass_count = 0;
    integer fail_count = 0;

    // Instantiate Saeed's top-level DES core
    des_core u_dut (
        .data_in  (tb_data_in),
        .key      (tb_key),
        .decrypt  (tb_decrypt),
        .data_out (tb_data_out)
    );

    // Also instantiate permutation loopback check for Zeyad's part
    wire [63:0] ip_test_out;
    wire [63:0] ip_loopback_out;

    des_initial_permutation u_tb_ip (
        .in_block  (tb_data_in),
        .out_block (ip_test_out)
    );

    des_inverse_initial_permutation u_tb_inv_ip (
        .in_block  (ip_test_out),
        .out_block (ip_loopback_out)
    );

    initial begin
        $display("================================================================");
        $display("               STARTING DES VERILOG VERIFICATION                ");
        $display("================================================================");

        // --------------------------------------------------------------------
        // TEST 1: Permutation Inversion Check (IP then IP^-1)
        // --------------------------------------------------------------------
        tb_data_in = 64'h0123456789ABCDEF;
        #5;
        if (ip_loopback_out === tb_data_in) begin
            $display("[PASS] Test 1: Permutation Inversion IP^-1(IP(data)) == data");
            pass_count = pass_count + 1;
        end else begin
            $display("[FAIL] Test 1: Permutation Inversion failed! Got %h, expected %h", ip_loopback_out, tb_data_in);
            fail_count = fail_count + 1;
        end

        // --------------------------------------------------------------------
        // TEST 2: Primary Known-Answer Vector (Encryption)
        // Key:        133457799BBCDFF1
        // Plaintext:  0123456789ABCDEF
        // Expected:   85E813540F0AB405
        // --------------------------------------------------------------------
        tb_key     = 64'h133457799BBCDFF1;
        tb_data_in = 64'h0123456789ABCDEF;
        tb_decrypt = 1'b0; // Encrypt
        #10;
        if (tb_data_out === 64'h85E813540F0AB405) begin
            $display("[PASS] Test 2: Standard Vector Encryption");
            $display("       Ciphertext: %h (Expected: 85e813540f0ab405)", tb_data_out);
            pass_count = pass_count + 1;
        end else begin
            $display("[FAIL] Test 2: Standard Vector Encryption Failed!");
            $display("       Got:      %h", tb_data_out);
            $display("       Expected: 85e813540f0ab405");
            fail_count = fail_count + 1;
        end

        // --------------------------------------------------------------------
        // TEST 3: Primary Known-Answer Vector (Decryption)
        // Ciphertext: 85E813540F0AB405
        // Expected:   0123456789ABCDEF
        // --------------------------------------------------------------------
        tb_data_in = 64'h85E813540F0AB405;
        tb_decrypt = 1'b1; // Decrypt
        #10;
        if (tb_data_out === 64'h0123456789ABCDEF) begin
            $display("[PASS] Test 3: Standard Vector Decryption");
            $display("       Plaintext:  %h (Expected: 0123456789abcdef)", tb_data_out);
            pass_count = pass_count + 1;
        end else begin
            $display("[FAIL] Test 3: Standard Vector Decryption Failed!");
            $display("       Got:      %h", tb_data_out);
            $display("       Expected: 0123456789abcdef");
            fail_count = fail_count + 1;
        end

        // --------------------------------------------------------------------
        // TEST 4: NIST Vector 2 (All zeros key & data)
        // Key:        0000000000000000
        // Plaintext:  0000000000000000
        // Expected:   8CA64DE9C1B123A7
        // --------------------------------------------------------------------
        tb_key     = 64'h0000000000000000;
        tb_data_in = 64'h0000000000000000;
        tb_decrypt = 1'b0;
        #10;
        if (tb_data_out === 64'h8CA64DE9C1B123A7) begin
            $display("[PASS] Test 4: All-Zero Vector Encryption");
            $display("       Ciphertext: %h (Expected: 8ca64de9c1b123a7)", tb_data_out);
            pass_count = pass_count + 1;
        end else begin
            $display("[FAIL] Test 4: All-Zero Vector Encryption Failed!");
            $display("       Got:      %h", tb_data_out);
            $display("       Expected: 8ca64de9c1b123a7");
            fail_count = fail_count + 1;
        end

        // --------------------------------------------------------------------
        // TEST 5: Decrypt Vector 4 back to zeros
        // --------------------------------------------------------------------
        tb_data_in = 64'h8CA64DE9C1B123A7;
        tb_decrypt = 1'b1;
        #10;
        if (tb_data_out === 64'h0000000000000000) begin
            $display("[PASS] Test 5: All-Zero Vector Decryption Recovery");
            pass_count = pass_count + 1;
        end else begin
            $display("[FAIL] Test 5: All-Zero Decryption Failed! Got %h", tb_data_out);
            fail_count = fail_count + 1;
        end

        // --------------------------------------------------------------------
        // SUMMARY
        // --------------------------------------------------------------------
        $display("================================================================");
        $display("TEST RESULTS: %0d PASSED, %0d FAILED", pass_count, fail_count);
        $display("================================================================");
        if (fail_count == 0) begin
            $display(">>> ALL DES VERILOG TESTS PASSED SUCCESSFULLY! <<<");
        end else begin
            $display(">>> SOME TESTS FAILED. CHECK LOGS ABOVE. <<<");
        end

        $finish;
    end

endmodule
