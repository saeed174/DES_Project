#ifndef ZEYAD_PERMUTATION_H
#define ZEYAD_PERMUTATION_H

#include <stdint.h>

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

#endif // ZEYAD_PERMUTATION_H
