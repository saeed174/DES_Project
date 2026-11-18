/**
 * @file main.c
 * @author Mohamed
 * @brief Binary-safe ECB File Encryption/Decryption CLI for DES.
 *
 * Team Members & Contributions:
 *   - Mohamed: CLI argument parsing, hex/raw key file parser, binary-safe file I/O
 *              preserving 0x00 bytes, and multi-block ECB encryption/decryption loop.
 *   - Saeed: Top-level DES block encrypt/decrypt core (des_core.h).
 *   - Zeyad: Permutation layer (IP, IP^-1, E, P).
 *   - Lotfy: Key schedule (PC-1, circular shifts, PC-2, K1..K16).
 *   - Marcelino (Marc): S-Boxes (S1..S8) and Round Function F(R, K).
 */

// Build & Run Examples (run from c_version/):
//   1) Build CLI:
//      gcc -O3 -Wall -Wextra permutation/*.c key_schedule/*.c round_function/*.c des_core/*.c cli_and_tests/main.c -o des_cli.exe
//
//   2) Build & run automated test suite:
//      gcc -O3 -Wall -Wextra permutation/*.c key_schedule/*.c round_function/*.c des_core/*.c cli_and_tests/test_des.c -o test_des_c.exe
//      .\test_des_c.exe
//
//   3) Test CLI directly - KAT 1 (Key: 133457799BBCDFF1, Expected CT: 85E813540F0AB405):
//      .\des_cli.exe e tests/keys/key_kat1_hex.txt tests/plaintexts/pt_kat1.txt ciphertext.bin
//      .\des_cli.exe d tests/keys/key_kat1_hex.txt ciphertext.bin recovered.bin
//
//   4) Test CLI directly - KAT 5 ASCII ("Now is t", Expected CT: 3FA40E8A984D4815):
//      .\des_cli.exe e tests/keys/key_ascii_hex_nl.txt tests/plaintexts/pt_kat5_ascii.txt ciphertext.bin
//      .\des_cli.exe d tests/keys/key_ascii_hex_nl.txt ciphertext.bin recovered.txt
//
//   5) Test CLI directly - Multi-block ASCII (24 bytes):
//      .\des_cli.exe e tests/keys/key_ascii_hex_nl.txt tests/plaintexts/pt_multiblock_ascii.txt ciphertext.bin
//      .\des_cli.exe d tests/keys/key_ascii_hex_nl.txt ciphertext.bin recovered.txt

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <ctype.h>
#include "../des_core/des_core.h"

// Parse key from file (supports 8 raw binary bytes or 16 hex characters)
static int read_key_file(const char *filename, uint64_t *key_out) {
    FILE *f = fopen(filename, "rb");
    if (!f) {
        fprintf(stderr, "Error: Could not open key file: %s\n", filename);
        return -1;
    }

    uint8_t buf[64];
    size_t n = fread(buf, 1, sizeof(buf), f);
    fclose(f);

    if (n < 8) {
        fprintf(stderr, "Error: Key file %s is too short (must be at least 8 bytes or 16 hex chars)\n", filename);
        return -1;
    }

    // Check if it is a 16-character hex string
    int is_hex = 1;
    for (size_t i = 0; i < 16; i++) {
        if (!isxdigit(buf[i])) {
            is_hex = 0;
            break;
        }
    }

    if (is_hex && (n == 16 || (n > 16 && (buf[16] == '\n' || buf[16] == '\r' || buf[16] == ' ')))) {
        char hex_str[17];
        memcpy(hex_str, buf, 16);
        hex_str[16] = '\0';
        *key_out = strtoull(hex_str, NULL, 16);
        return 0;
    }

    // Otherwise, treat as 8 raw binary bytes (Big Endian)
    uint64_t raw_key = 0;
    for (int i = 0; i < 8; i++) {
        raw_key = (raw_key << 8) | (uint64_t)buf[i];
    }
    *key_out = raw_key;
    return 0;
}

// Convert 8 bytes from buffer to uint64_t (Big-Endian)
static uint64_t bytes_to_u64(const uint8_t *b) {
    return (((uint64_t)b[0]) << 56) |
           (((uint64_t)b[1]) << 48) |
           (((uint64_t)b[2]) << 40) |
           (((uint64_t)b[3]) << 32) |
           (((uint64_t)b[4]) << 24) |
           (((uint64_t)b[5]) << 16) |
           (((uint64_t)b[6]) << 8)  |
           (((uint64_t)b[7]));
}

// Write uint64_t to 8 bytes in buffer (Big-Endian)
static void u64_to_bytes(uint64_t val, uint8_t *b) {
    b[0] = (uint8_t)(val >> 56);
    b[1] = (uint8_t)(val >> 48);
    b[2] = (uint8_t)(val >> 40);
    b[3] = (uint8_t)(val >> 32);
    b[4] = (uint8_t)(val >> 24);
    b[5] = (uint8_t)(val >> 16);
    b[6] = (uint8_t)(val >> 8);
    b[7] = (uint8_t)(val);
}

int main(int argc, char *argv[]) {
    // Usage:
    //   program e key_file plaintext_file ciphertext_file
    //   program d key_file ciphertext_file plaintext_file
    if (argc != 5) {
#ifdef _WIN32
        const char *cli_cmd = ".\\des_cli.exe";
#else
        const char *cli_cmd = "./des_cli";
#endif
        fprintf(stderr, "Usage: %s <e|d> <key_file> <input_file> <output_file>\n", argv[0]);
        fprintf(stderr, "  e : Encrypt\n");
        fprintf(stderr, "  d : Decrypt\n\n");
        fprintf(stderr, "Examples (run from c_version/):\n");
        fprintf(stderr, "  %s e tests/keys/key_kat1_hex.txt tests/plaintexts/pt_kat1.txt ciphertext.bin\n", cli_cmd);
        fprintf(stderr, "  %s d tests/keys/key_kat1_hex.txt ciphertext.bin recovered.bin\n", cli_cmd);
        fprintf(stderr, "  %s e tests/keys/key_ascii_hex_nl.txt tests/plaintexts/pt_kat5_ascii.txt ciphertext.bin\n", cli_cmd);
        fprintf(stderr, "  %s d tests/keys/key_ascii_hex_nl.txt ciphertext.bin recovered.txt\n", cli_cmd);
        return 1;
    }

    char mode = argv[1][0];
    if (mode != 'e' && mode != 'd') {
        fprintf(stderr, "Error: Unknown mode '%c'. Use 'e' for encrypt or 'd' for decrypt.\n", mode);
        return 1;
    }

    const char *key_file = argv[2];
    const char *in_file  = argv[3];
    const char *out_file = argv[4];

    uint64_t key = 0;
    if (read_key_file(key_file, &key) != 0) {
        return 1;
    }

    FILE *fin = fopen(in_file, "rb");
    if (!fin) {
        fprintf(stderr, "Error: Could not open input file: %s\n", in_file);
        return 1;
    }

    FILE *fout = fopen(out_file, "wb");
    if (!fout) {
        fprintf(stderr, "Error: Could not open output file: %s\n", out_file);
        fclose(fin);
        return 1;
    }

    uint8_t in_buf[8];
    uint8_t out_buf[8];
    size_t bytes_read = 0;
    size_t total_blocks = 0;

    // Process file in ECB mode, 8 bytes per block
    while ((bytes_read = fread(in_buf, 1, 8, fin)) > 0) {
        if (bytes_read < 8) {
            // Assignment specifies: input length is multiple of 8 bytes, no padding needed.
            // If an unaligned block occurs, zero-pad it.
            memset(in_buf + bytes_read, 0, 8 - bytes_read);
        }

        uint64_t block = bytes_to_u64(in_buf);
        uint64_t processed_block;

        if (mode == 'e') {
            processed_block = des_encrypt_block(block, key);
        } else {
            processed_block = des_decrypt_block(block, key);
        }

        u64_to_bytes(processed_block, out_buf);
        fwrite(out_buf, 1, 8, fout);
        total_blocks++;
    }

    fclose(fin);
    fclose(fout);

    return 0;
}
