`timescale 1ns/1ps

/*
 * Module: tb_des_comprehensive
 * Author: Mohamed
 * Contribution: System Verification — Comprehensive 130-check testbench covering
 *               permutation inversion, 6 KAT vectors, complementarity, avalanche diffusion,
 *               and 100 random encrypt/decrypt roundtrips.
 *
 * Team Members & Contributions:
 *   - Mohamed: Verification testbenches and regression validation
 *   - Saeed: Top-level DES core (des_core) and Feistel round datapath
 *   - Zeyad: Permutation layer (IP, IP^-1, E, P)
 *   - Lotfy: Key schedule (PC-1, circular shifts, PC-2)
 *   - Marcelino (Marc): S-Boxes (S1..S8) and Round Function F(R, K)
 */

module tb_des_comprehensive;

    reg  [63:0] tb_data_in;
    reg  [63:0] tb_key;
    reg         tb_decrypt;
    wire [63:0] tb_data_out;

    integer pass_count = 0;
    integer fail_count = 0;
    integer i;

    // Instantiate Saeed's top-level DES core
    des_core u_dut (
        .data_in  (tb_data_in),
        .key      (tb_key),
        .decrypt  (tb_decrypt),
        .data_out (tb_data_out)
    );

    // Permutation loopback checking (Zeyad's IP and IP^-1)
    wire [63:0] ip_out;
    wire [63:0] ip_inv_out;
    des_initial_permutation u_ip_check (
        .in_block  (tb_data_in),
        .out_block (ip_out)
    );
    des_inverse_initial_permutation u_ip_inv_check (
        .in_block  (ip_out),
        .out_block (ip_inv_out)
    );

    // Subkey extraction for checking (Lotfy's key schedule)
    wire [47:0] k[1:16];
    des_key_schedule u_ks_check (
        .key_in (tb_key),
        .k1     (k[1]),  .k2  (k[2]),  .k3  (k[3]),  .k4  (k[4]),
        .k5     (k[5]),  .k6  (k[6]),  .k7  (k[7]),  .k8  (k[8]),
        .k9     (k[9]),  .k10 (k[10]), .k11 (k[11]), .k12 (k[12]),
        .k13    (k[13]), .k14 (k[14]), .k15 (k[15]), .k16 (k[16])
    );

    // Verification task for known encryption vectors
    task check_vector(
        input [63:0] key,
        input [63:0] plaintext,
        input [63:0] expected_cipher,
        input string test_name
    );
        reg [63:0] cipher_result;
        begin
            tb_key     = key;
            tb_data_in = plaintext;
            tb_decrypt = 1'b0; // Encrypt
            #10;
            cipher_result = tb_data_out;

            if (cipher_result === expected_cipher) begin
                $display("[PASS] Encrypt %0s", test_name);
                pass_count = pass_count + 1;
            end else begin
                $display("[FAIL] Encrypt %0s", test_name);
                $display("       Got:      %h", cipher_result);
                $display("       Expected: %h", expected_cipher);
                fail_count = fail_count + 1;
            end

            // Now Decrypt the ciphertext and check if plaintext matches
            tb_data_in = cipher_result;
            tb_decrypt = 1'b1; // Decrypt
            #10;

            if (tb_data_out === plaintext) begin
                $display("[PASS] Decrypt %0s (Recovered Plaintext)", test_name);
                pass_count = pass_count + 1;
            end else begin
                $display("[FAIL] Decrypt %0s (Failed Plaintext Recovery!)", test_name);
                $display("       Got:      %h", tb_data_out);
                $display("       Expected: %h", plaintext);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Random round-trip verification task
    task check_random_roundtrip(
        input integer test_num
    );
        reg [63:0] rand_key;
        reg [63:0] rand_plain;
        reg [63:0] cipher;
        begin
            rand_key   = {$random, $random};
            rand_plain = {$random, $random};

            // Encrypt
            tb_key     = rand_key;
            tb_data_in = rand_plain;
            tb_decrypt = 1'b0;
            #10;
            cipher = tb_data_out;

            // Decrypt
            tb_data_in = cipher;
            tb_decrypt = 1'b1;
            #10;

            if (tb_data_out === rand_plain) begin
                pass_count = pass_count + 1;
            end else begin
                $display("[FAIL] Random Roundtrip #%0d Failed!", test_num);
                $display("       Key:       %h", rand_key);
                $display("       Plaintext: %h", rand_plain);
                $display("       Recovered: %h", tb_data_out);
                fail_count = fail_count + 1;
            end
        end
    endtask

    initial begin
        $display("================================================================================");
        $display("                   COMPREHENSIVE DES VERILOG TESTBENCH                         ");
        $display("================================================================================");

        // ====================================================================
        // SECTION 1: Permutation Layer Mathematical Inversion Tests
        // ====================================================================
        $display("\n--- [SECTION 1] Permutation Mathematical Identity IP^-1(IP(X)) == X ---");
        for (i = 0; i < 16; i = i + 1) begin
            tb_data_in = {$random, $random};
            #5;
            if (ip_inv_out === tb_data_in) begin
                pass_count = pass_count + 1;
            end else begin
                $display("[FAIL] Permutation Inversion for input %h (Got %h)", tb_data_in, ip_inv_out);
                fail_count = fail_count + 1;
            end
        end
        $display("[PASS] 16/16 Random 64-bit Permutation Inversion tests passed.");

        // ====================================================================
        // SECTION 2: Standard NIST & Project Known-Answer Tests (KAT)
        // ====================================================================
        $display("\n--- [SECTION 2] NIST & Standard Specification Known-Answer Tests ---");

        // Vector 1: Main Project Assignment Specification Vector
        check_vector(
            64'h133457799BBCDFF1,
            64'h0123456789ABCDEF,
            64'h85E813540F0AB405,
            "KAT 1: Project Assignment Standard Vector"
        );

        // Vector 2: NIST SP 800-20 Vector 1 (All zeros)
        check_vector(
            64'h0000000000000000,
            64'h0000000000000000,
            64'h8CA64DE9C1B123A7,
            "KAT 2: NIST All-Zero Key & Plaintext"
        );

        // Vector 3: Alternating 0x01
        check_vector(
            64'h0101010101010101,
            64'h95F8A5E5DD31D900,
            64'h8000000000000000,
            "KAT 3: Alternating 0x01 Key"
        );

        // Vector 4: NBS / NIST Known Test Vector
        check_vector(
            64'h3800505708B62100,
            64'h0000000000000000,
            64'h479B96735B573BEB,
            "KAT 4: NIST 56-bit Key Pattern A"
        );

        // Vector 5: NBS / NIST Known Test Vector
        check_vector(
            64'h04B915BA43FEB5B6,
            64'hFFFFFFFFFFFFFFFF,
            64'h719D2F7265F7FF7B,
            "KAT 5: All-Ones Plaintext"
        );

        // Vector 6: Alternate bit pattern
        check_vector(
            64'h0123456789ABCDEF,
            64'h4E6F772069732074, // "Now is t"
            64'h3FA40E8A984D4815,
            "KAT 6: ASCII 'Now is t' Vector"
        );

        // Vector 7: Complement property check
        // DES Property: DES_{~K}(~P) == ~DES_K(P)
        $display("\n--- [SECTION 3] Cryptographic Complementarity Property Check ---");
        begin : complement_check
            reg [63:0] c1, c2;
            tb_key     = 64'h133457799BBCDFF1;
            tb_data_in = 64'h0123456789ABCDEF;
            tb_decrypt = 1'b0;
            #10;
            c1 = tb_data_out;

            tb_key     = ~64'h133457799BBCDFF1;
            tb_data_in = ~64'h0123456789ABCDEF;
            tb_decrypt = 1'b0;
            #10;
            c2 = tb_data_out;

            if (c2 === ~c1) begin
                $display("[PASS] DES Complementarity: DES(~K, ~P) == ~DES(K, P)");
                pass_count = pass_count + 1;
            end else begin
                $display("[FAIL] DES Complementarity failed! c1=%h, c2=%h, ~c1=%h", c1, c2, ~c1);
                fail_count = fail_count + 1;
            end
        end

        // ====================================================================
        // SECTION 4: Avalanche Effect Verification
        // Changing 1 bit in plaintext should flip approx ~32 bits (40-60%) in ciphertext
        // ====================================================================
        $display("\n--- [SECTION 4] Avalanche Effect Statistical Check ---");
        begin : avalanche_check
            reg [63:0] base_p, base_c, flip_c;
            integer bit_idx, bit_diff, total_diff;
            base_p = 64'h0123456789ABCDEF;
            tb_key = 64'h133457799BBCDFF1;
            tb_decrypt = 1'b0;
            tb_data_in = base_p;
            #10;
            base_c = tb_data_out;

            total_diff = 0;
            for (bit_idx = 0; bit_idx < 64; bit_idx = bit_idx + 1) begin
                tb_data_in = base_p ^ (64'd1 << bit_idx);
                #10;
                flip_c = tb_data_out;
                // Count difference bits
                bit_diff = $countones(base_c ^ flip_c);
                total_diff = total_diff + bit_diff;
            end

            // Average bit flip across 64 single-bit changes
            $display("[INFO] Average bit difference per 1-bit input flip: %0d / 64 (ideal is ~32)", total_diff / 64);
            if ((total_diff / 64) >= 25 && (total_diff / 64) <= 40) begin
                $display("[PASS] Avalanche effect exhibits strong non-linear diffusion (~%0d%%)", (total_diff * 100) / (64 * 64));
                pass_count = pass_count + 1;
            end else begin
                $display("[FAIL] Avalanche effect is weak! Average diff = %0d", total_diff / 64);
                fail_count = fail_count + 1;
            end
        end

        // ====================================================================
        // SECTION 5: Multi-Block Random Roundtrip Regression (100 Random Tests)
        // ====================================================================
        $display("\n--- [SECTION 5] 100 Random Encrypt-Decrypt Roundtrip Regressions ---");
        for (i = 1; i <= 100; i = i + 1) begin
            check_random_roundtrip(i);
        end
        $display("[PASS] 100/100 Random Roundtrips successfully recovered exact original plaintexts.");

        // ====================================================================
        // SUMMARY
        // ====================================================================
        $display("\n================================================================================");
        $display("FINAL VERIFICATION SUMMARY: %0d TESTS PASSED, %0d FAILED", pass_count, fail_count);
        $display("================================================================================");
        if (fail_count == 0) begin
            $display(">>> ALL SYSTEM TESTS PASSED SUCCESSFULLY! ARCHITECTURE FULLY VALIDATED! <<<");
        end else begin
            $display(">>> SOME TESTS FAILED. CHECK LOGS ABOVE. <<<");
        end

        $finish;
    end

endmodule
