#ifndef DES_KEY_SCHEDULE_H
#define DES_KEY_SCHEDULE_H

#include <stdint.h>

/**
 * @file des_key_schedule.h
 * @author Lotfy
 * @brief DES Key Schedule: PC-1, circular left shifts, PC-2, and 16 subkeys generation.
 *
 * Team Member & Contribution:
 *   - Lotfy: Implemented the DES key schedule (PC-1 parity drop, 28-bit circular
 *            left shifts, PC-2 compression, and generation of K1..K16).
 */

#ifdef __cplusplus
extern "C" {
#endif

/**
 * @brief Generates all 16 48-bit round subkeys from the 64-bit input key.
 * @param key 64-bit original key
 * @param subkeys Array of 16 uint64_t to receive subkeys K1..K16 (each stored in lower 48 bits)
 */
void des_generate_subkeys(uint64_t key, uint64_t subkeys[16]);

#ifdef __cplusplus
}
#endif

#endif // DES_KEY_SCHEDULE_H
