#ifndef DES_CORE_H
#define DES_CORE_H

#include <stdint.h>

/**
 * @file des_core.h
 * @author Saeed
 * @brief Top-Level DES Core: 16 Feistel rounds, Encrypt/Decrypt block functions.
 *
 * Team Member & Contribution:
 *   - Saeed: Designed and implemented the top-level 64-bit DES core and
 *            16-round Feistel network supporting encryption and decryption.
 */

#ifdef __cplusplus
extern "C" {
#endif

/**
 * @brief Encrypts a single 64-bit block using a 64-bit key.
 * @param block 64-bit plaintext block
 * @param key 64-bit key
 * @return 64-bit ciphertext block
 */
uint64_t des_encrypt_block(uint64_t block, uint64_t key);

/**
 * @brief Decrypts a single 64-bit block using a 64-bit key.
 * @param block 64-bit ciphertext block
 * @param key 64-bit key
 * @return 64-bit decrypted plaintext block
 */
uint64_t des_decrypt_block(uint64_t block, uint64_t key);

#ifdef __cplusplus
}
#endif

#endif // DES_CORE_H
