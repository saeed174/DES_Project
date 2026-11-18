#include "des_core.h"
#include "../zeyad/des_permutation.h"
#include "../lotfy/des_key_schedule.h"
#include "../marc/des_round_function.h"

static uint64_t des_process_block(uint64_t block, uint64_t key, int decrypt) {
    // 1. Generate all 16 subkeys using Lotfy's key schedule
    uint64_t subkeys[16];
    des_generate_subkeys(key, subkeys);

    // 2. Initial Permutation using Zeyad's function
    uint64_t permuted = des_initial_permutation(block);

    // 3. Split into 32-bit halves L and R
    uint32_t l = (uint32_t)(permuted >> 32);
    uint32_t r = (uint32_t)(permuted & 0xFFFFFFFFU);

    // 4. 16 Feistel rounds
    for (int i = 0; i < 16; i++) {
        // Subkey selection: K1..K16 for encryption, K16..K1 for decryption
        uint64_t round_key = decrypt ? subkeys[15 - i] : subkeys[i];

        uint32_t next_l = r;
        uint32_t next_r = l ^ des_round_function_f(r, round_key);

        l = next_l;
        r = next_r;
    }

    // 5. Pre-output block swapping: {R[16], L[16]}
    uint64_t pre_output = (((uint64_t)r) << 32) | (uint64_t)l;

    // 6. Inverse Initial Permutation using Zeyad's function
    return des_inverse_initial_permutation(pre_output);
}

uint64_t des_encrypt_block(uint64_t block, uint64_t key) {
    return des_process_block(block, key, 0);
}

uint64_t des_decrypt_block(uint64_t block, uint64_t key) {
    return des_process_block(block, key, 1);
}
