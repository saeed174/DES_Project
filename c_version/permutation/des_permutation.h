#ifndef DES_PERMUTATION_H
#define DES_PERMUTATION_H

#include <stdint.h>

/**
 * @file des_permutation.h
 * @author Zeyad
 * @brief Permutation Layer: Initial Permutation (IP), Inverse Initial Permutation (IP^-1),
 *        Expansion Permutation (E), and P-Permutation (P).
 *
 * Team Member & Contribution:
 *   - Zeyad: Designed and implemented all bit-level DES permutation tables and functions
 *            (IP, IP^-1, E, and P) used across key mixing and Feistel rounds.
 */

#ifdef __cplusplus
extern "C" {
#endif

uint64_t des_initial_permutation(uint64_t in_block);

uint64_t des_inverse_initial_permutation(uint64_t in_block);

uint64_t des_expansion_permutation(uint32_t in_r);

uint32_t des_p_permutation(uint32_t in_p);

#ifdef __cplusplus
}
#endif

#endif // DES_PERMUTATION_H
