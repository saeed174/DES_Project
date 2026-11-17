#include "des_key_schedule.h"

// PC-1 Table: 56 bits (C0: first 28, D0: second 28), 1-indexed from key MSB [64..1]
static const uint8_t PC1_TABLE[56] = {
    // C0 (28 bits)
    57, 49, 41, 33, 25, 17,  9,
     1, 58, 50, 42, 34, 26, 18,
    10,  2, 59, 51, 43, 35, 27,
    19, 11,  3, 60, 52, 44, 36,
    // D0 (28 bits)
    63, 55, 47, 39, 31, 23, 15,
     7, 62, 54, 46, 38, 30, 22,
    14,  6, 61, 53, 45, 37, 29,
    21, 13,  5, 28, 20, 12,  4
};

// Round left-shift schedule for rounds 1..16
static const uint8_t SHIFT_SCHEDULE[16] = {
    1, 1, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 1
};

// PC-2 Table: 48 bits, 1-indexed from 56-bit {C, D} MSB [56..1]
static const uint8_t PC2_TABLE[48] = {
    14, 17, 11, 24,  1,  5,
     3, 28, 15,  6, 21, 10,
    23, 19, 12,  4, 26,  8,
    16,  7, 27, 20, 13,  2,
    41, 52, 31, 37, 47, 55,
    30, 40, 51, 45, 33, 48,
    44, 49, 39, 56, 34, 53,
    46, 42, 50, 36, 29, 32
};

static uint32_t left_rot_28(uint32_t val, uint8_t shift) {
    val &= 0x0FFFFFFFU;
    return ((val << shift) | (val >> (28 - shift))) & 0x0FFFFFFFU;
}

void des_generate_subkeys(uint64_t key, uint64_t subkeys[16]) {
    uint32_t c = 0;
    uint32_t d = 0;

    // Apply PC-1
    for (int i = 0; i < 28; i++) {
        uint8_t bit_pos = PC1_TABLE[i]; // 1..64
        uint32_t bit = (uint32_t)((key >> (64 - bit_pos)) & 1ULL);
        c = (c << 1) | bit;
    }
    for (int i = 28; i < 56; i++) {
        uint8_t bit_pos = PC1_TABLE[i]; // 1..64
        uint32_t bit = (uint32_t)((key >> (64 - bit_pos)) & 1ULL);
        d = (d << 1) | bit;
    }

    // 16 rounds
    for (int r = 0; r < 16; r++) {
        c = left_rot_28(c, SHIFT_SCHEDULE[r]);
        d = left_rot_28(d, SHIFT_SCHEDULE[r]);

        uint64_t cd = (((uint64_t)c) << 28) | (uint64_t)d; // 56 bits
        uint64_t subkey = 0;

        // Apply PC-2
        for (int i = 0; i < 48; i++) {
            uint8_t bit_pos = PC2_TABLE[i]; // 1..56
            uint64_t bit = (cd >> (56 - bit_pos)) & 1ULL;
            subkey = (subkey << 1) | bit;
        }

        subkeys[r] = subkey;
    }
}
