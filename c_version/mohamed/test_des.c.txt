#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <inttypes.h>
#include "../saeed/des_core.h"
#include "../zeyad/des_permutation.h"

static int pass_count = 0;
static int fail_count = 0;

static void check_vector(uint64_t key, uint64_t plaintext, uint64_t expected_cipher, const char *name) {
    uint64_t cipher = des_encrypt_block(plaintext, key);
    if (cipher == expected_cipher) {
        printf("[PASS] Encrypt %s\n", name);
        pass_count++;
    } else {
        printf("[FAIL] Encrypt %s\n", name);
        printf("       Got:      0x%016" PRIX64 "\n", cipher);
        printf("       Expected: 0x%016" PRIX64 "\n", expected_cipher);
        fail_count++;
    }

    uint64_t recovered = des_decrypt_block(cipher, key);
    if (recovered == plaintext) {
        printf("[PASS] Decrypt %s (Plaintext Recovered)\n", name);
        pass_count++;
    } else {
        printf("[FAIL] Decrypt %s (Plaintext Recovery Failed!)\n", name);
        printf("       Got:      0x%016" PRIX64 "\n", recovered);
        printf("       Expected: 0x%016" PRIX64 "\n", plaintext);
        fail_count++;
    }
}

static uint64_t rand64(void) {
    uint64_t r = 0;
    for (int i = 0; i < 4; i++) {
        r = (r << 16) | (uint64_t)(rand() & 0xFFFF);
    }
    return r;
}

int main(void) {
    printf("================================================================================\n");
    printf("                     DES C-VERSION VERIFICATION SUITE                           \n");
    printf("================================================================================\n");

    // 1. Permutation loopback check
    printf("\n--- [SECTION 1] Permutation Mathematical Identity IP^-1(IP(X)) == X ---\n");
    int perm_ok = 1;
    for (int i = 0; i < 50; i++) {
        uint64_t val = rand64();
        uint64_t ip = des_initial_permutation(val);
        uint64_t loopback = des_inverse_initial_permutation(ip);
        if (loopback != val) {
            perm_ok = 0;
            printf("[FAIL] IP loopback failed for 0x%016" PRIX64 "\n", val);
            fail_count++;
            break;
        }
    }
    if (perm_ok) {
        printf("[PASS] 50/50 Random 64-bit Permutation Inversion tests passed.\n");
        pass_count++;
    }

    // 2. Standard Known-Answer Tests
    printf("\n--- [SECTION 2] Standard Known-Answer Tests (KAT) ---\n");
    // KAT 1: Project Assignment Standard Vector
    check_vector(0x133457799BBCDFF1ULL, 0x0123456789ABCDEFULL, 0x85E813540F0AB405ULL, "KAT 1: Project Assignment Vector");

    // KAT 2: NIST All-Zero Key & Plaintext
    check_vector(0x0000000000000000ULL, 0x0000000000000000ULL, 0x8CA64DE9C1B123A7ULL, "KAT 2: NIST All-Zero Vector");

    // KAT 3: NIST 56-bit Key Pattern A
    check_vector(0x3800505708B62100ULL, 0x0000000000000000ULL, 0x479B96735B573BEBULL, "KAT 3: NIST 56-bit Key Pattern A");

    // KAT 4: All-Ones Plaintext
    check_vector(0x04B915BA43FEB5B6ULL, 0xFFFFFFFFFFFFFFFFULL, 0x719D2F7265F7FF7BULL, "KAT 4: All-Ones Plaintext");

    // KAT 5: ASCII Vector "Now is t"
    check_vector(0x0123456789ABCDEFULL, 0x4E6F772069732074ULL, 0x3FA40E8A984D4815ULL, "KAT 5: ASCII 'Now is t'");

    // 3. Cryptographic Complementarity Check
    printf("\n--- [SECTION 3] Cryptographic Complementarity Check ---\n");
    uint64_t c1 = des_encrypt_block(0x0123456789ABCDEFULL, 0x133457799BBCDFF1ULL);
    uint64_t c2 = des_encrypt_block(~0x0123456789ABCDEFULL, ~0x133457799BBCDFF1ULL);
    if (c2 == ~c1) {
        printf("[PASS] DES Complementarity: DES(~K, ~P) == ~DES(K, P)\n");
        pass_count++;
    } else {
        printf("[FAIL] DES Complementarity failed!\n");
        fail_count++;
    }

    // 4. Randomized Roundtrips (1000 pairs)
    printf("\n--- [SECTION 4] 1000 Random Encrypt-Decrypt Roundtrips ---\n");
    int roundtrip_ok = 1;
    for (int i = 0; i < 1000; i++) {
        uint64_t k = rand64();
        uint64_t p = rand64();
        uint64_t c = des_encrypt_block(p, k);
        uint64_t dec = des_decrypt_block(c, k);
        if (dec != p) {
            roundtrip_ok = 0;
            printf("[FAIL] Random roundtrip failed at iteration %d\n", i);
            fail_count++;
            break;
        }
    }
    if (roundtrip_ok) {
        printf("[PASS] 1000/1000 Random Encrypt-Decrypt Roundtrips successfully recovered!\n");
        pass_count++;
    }

    printf("\n================================================================================\n");
    printf("FINAL C VERIFICATION SUMMARY: %d PASSED, %d FAILED\n", pass_count, fail_count);
    printf("================================================================================\n");

    return fail_count == 0 ? 0 : 1;
}
