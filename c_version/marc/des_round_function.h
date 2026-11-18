#ifndef MARC_ROUND_FUNCTION_H
#define MARC_ROUND_FUNCTION_H

#include <stdint.h>

/**
 * @file des_round_function.h
 * @author Marc
 * @brief DES S-Boxes and Round Function F: F(R, K).
 */

#ifdef __cplusplus
extern "C" {
#endif

/**
 * @brief Performs standard DES S-box substitution (48 bits -> 32 bits).
 * @param in_48 48-bit input (lower 48 bits of uint64_t)
 * @return 32-bit substituted output
 */
uint32_t des_sboxes_lookup(uint64_t in_48);

/**
 * @brief Complete DES Round Function F(R, K).
 * Expands 32-bit R -> 48 bits, XOR with 48-bit K, S-Boxes -> 32 bits, P-Permutation -> 32 bits.
 * @param right_half 32-bit Right block
 * @param round_key 48-bit Round Subkey
 * @return 32-bit F function output
 */
uint32_t des_round_function_f(uint32_t right_half, uint64_t round_key);

#ifdef __cplusplus
}
#endif

#endif // MARC_ROUND_FUNCTION_H
