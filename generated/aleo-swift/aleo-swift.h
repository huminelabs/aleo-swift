// File automatically generated by swift-bridge.
#include <stdint.h>
#include <stdbool.h>
bool __swift_bridge__$RField$_partial_eq(void* lhs, void* rhs);
typedef struct RField RField;
void __swift_bridge__$RField$_free(void* self);

void* __swift_bridge__$Vec_RField$new(void);
void __swift_bridge__$Vec_RField$drop(void* vec_ptr);
void __swift_bridge__$Vec_RField$push(void* vec_ptr, void* item_ptr);
void* __swift_bridge__$Vec_RField$pop(void* vec_ptr);
void* __swift_bridge__$Vec_RField$get(void* vec_ptr, uintptr_t index);
void* __swift_bridge__$Vec_RField$get_mut(void* vec_ptr, uintptr_t index);
uintptr_t __swift_bridge__$Vec_RField$len(void* vec_ptr);
void* __swift_bridge__$Vec_RField$as_ptr(void* vec_ptr);

void* __swift_bridge__$RField$r_to_string(void* self);
void* __swift_bridge__$RField$r_from_string(struct RustStr string);


// File automatically generated by swift-bridge.
#include <stdint.h>
#include <stdbool.h>
bool __swift_bridge__$RAddress$_partial_eq(void* lhs, void* rhs);
typedef struct RAddress RAddress;
void __swift_bridge__$RAddress$_free(void* self);

void* __swift_bridge__$Vec_RAddress$new(void);
void __swift_bridge__$Vec_RAddress$drop(void* vec_ptr);
void __swift_bridge__$Vec_RAddress$push(void* vec_ptr, void* item_ptr);
void* __swift_bridge__$Vec_RAddress$pop(void* vec_ptr);
void* __swift_bridge__$Vec_RAddress$get(void* vec_ptr, uintptr_t index);
void* __swift_bridge__$Vec_RAddress$get_mut(void* vec_ptr, uintptr_t index);
uintptr_t __swift_bridge__$Vec_RAddress$len(void* vec_ptr);
void* __swift_bridge__$Vec_RAddress$as_ptr(void* vec_ptr);

void* __swift_bridge__$RAddress$r_from_private_key(void* private_key);
void* __swift_bridge__$RAddress$r_from_view_key(void* view_key);
void* __swift_bridge__$RAddress$r_from_string(void* address);
void* __swift_bridge__$RAddress$r_to_string(void* self);
bool __swift_bridge__$RAddress$r_verify(void* self, struct __private__FfiSlice message, void* signature);


// File automatically generated by swift-bridge.
#include <stdint.h>
#include <stdbool.h>
bool __swift_bridge__$RPrivateKeyCiphertext$_partial_eq(void* lhs, void* rhs);
typedef struct RPrivateKeyCiphertext RPrivateKeyCiphertext;
void __swift_bridge__$RPrivateKeyCiphertext$_free(void* self);

void* __swift_bridge__$Vec_RPrivateKeyCiphertext$new(void);
void __swift_bridge__$Vec_RPrivateKeyCiphertext$drop(void* vec_ptr);
void __swift_bridge__$Vec_RPrivateKeyCiphertext$push(void* vec_ptr, void* item_ptr);
void* __swift_bridge__$Vec_RPrivateKeyCiphertext$pop(void* vec_ptr);
void* __swift_bridge__$Vec_RPrivateKeyCiphertext$get(void* vec_ptr, uintptr_t index);
void* __swift_bridge__$Vec_RPrivateKeyCiphertext$get_mut(void* vec_ptr, uintptr_t index);
uintptr_t __swift_bridge__$Vec_RPrivateKeyCiphertext$len(void* vec_ptr);
void* __swift_bridge__$Vec_RPrivateKeyCiphertext$as_ptr(void* vec_ptr);

void* __swift_bridge__$RPrivateKeyCiphertext$r_encrypt_private_key(void* private_key, struct RustStr secret);
void* __swift_bridge__$RPrivateKeyCiphertext$r_decrypt_to_private_key(void* self, struct RustStr secret);
void* __swift_bridge__$RPrivateKeyCiphertext$r_to_string(void* self);
void* __swift_bridge__$RPrivateKeyCiphertext$r_from_string(void* string);


// File automatically generated by swift-bridge.
#include <stdint.h>
#include <stdbool.h>
bool __swift_bridge__$RPrivateKey$_partial_eq(void* lhs, void* rhs);
typedef struct RPrivateKey RPrivateKey;
void __swift_bridge__$RPrivateKey$_free(void* self);

void* __swift_bridge__$Vec_RPrivateKey$new(void);
void __swift_bridge__$Vec_RPrivateKey$drop(void* vec_ptr);
void __swift_bridge__$Vec_RPrivateKey$push(void* vec_ptr, void* item_ptr);
void* __swift_bridge__$Vec_RPrivateKey$pop(void* vec_ptr);
void* __swift_bridge__$Vec_RPrivateKey$get(void* vec_ptr, uintptr_t index);
void* __swift_bridge__$Vec_RPrivateKey$get_mut(void* vec_ptr, uintptr_t index);
uintptr_t __swift_bridge__$Vec_RPrivateKey$len(void* vec_ptr);
void* __swift_bridge__$Vec_RPrivateKey$as_ptr(void* vec_ptr);

void* __swift_bridge__$RPrivateKey$new(void);
void* __swift_bridge__$RPrivateKey$r_from_seed_unchecked(struct __private__FfiSlice seed);
void* __swift_bridge__$RPrivateKey$r_from_string(struct RustStr private_key);
void* __swift_bridge__$RPrivateKey$r_to_string(void* self);
void* __swift_bridge__$RPrivateKey$r_to_view_key(void* self);
void* __swift_bridge__$RPrivateKey$r_to_address(void* self);
void* __swift_bridge__$RPrivateKey$r_sign(void* self, struct __private__FfiSlice message);
void* __swift_bridge__$RPrivateKey$r_new_encrypted(struct RustStr secret);
void* __swift_bridge__$RPrivateKey$r_to_ciphertext(void* self, struct RustStr secret);
void* __swift_bridge__$RPrivateKey$r_from_private_key_ciphertext(void* ciphertext, struct RustStr secret);


// File automatically generated by swift-bridge.
#include <stdint.h>
#include <stdbool.h>
typedef struct RSignature RSignature;
void __swift_bridge__$RSignature$_free(void* self);

void* __swift_bridge__$Vec_RSignature$new(void);
void __swift_bridge__$Vec_RSignature$drop(void* vec_ptr);
void __swift_bridge__$Vec_RSignature$push(void* vec_ptr, void* item_ptr);
void* __swift_bridge__$Vec_RSignature$pop(void* vec_ptr);
void* __swift_bridge__$Vec_RSignature$get(void* vec_ptr, uintptr_t index);
void* __swift_bridge__$Vec_RSignature$get_mut(void* vec_ptr, uintptr_t index);
uintptr_t __swift_bridge__$Vec_RSignature$len(void* vec_ptr);
void* __swift_bridge__$Vec_RSignature$as_ptr(void* vec_ptr);

void* __swift_bridge__$RSignature$r_sign(void* private_key, struct __private__FfiSlice message);
bool __swift_bridge__$RSignature$r_verify(void* self, void* address, struct __private__FfiSlice message);
void* __swift_bridge__$RSignature$r_from_string(struct RustStr signature);
void* __swift_bridge__$RSignature$r_to_string(void* self);


// File automatically generated by swift-bridge.
#include <stdint.h>
#include <stdbool.h>
bool __swift_bridge__$RViewKey$_partial_eq(void* lhs, void* rhs);
typedef struct RViewKey RViewKey;
void __swift_bridge__$RViewKey$_free(void* self);

void* __swift_bridge__$Vec_RViewKey$new(void);
void __swift_bridge__$Vec_RViewKey$drop(void* vec_ptr);
void __swift_bridge__$Vec_RViewKey$push(void* vec_ptr, void* item_ptr);
void* __swift_bridge__$Vec_RViewKey$pop(void* vec_ptr);
void* __swift_bridge__$Vec_RViewKey$get(void* vec_ptr, uintptr_t index);
void* __swift_bridge__$Vec_RViewKey$get_mut(void* vec_ptr, uintptr_t index);
uintptr_t __swift_bridge__$Vec_RViewKey$len(void* vec_ptr);
void* __swift_bridge__$Vec_RViewKey$as_ptr(void* vec_ptr);

void* __swift_bridge__$RViewKey$r_from_private_key(void* private_key);
void* __swift_bridge__$RViewKey$r_from_string(struct RustStr view_key);
void* __swift_bridge__$RViewKey$r_to_string(void* self);
void* __swift_bridge__$RViewKey$r_to_address(void* self);
void* __swift_bridge__$RViewKey$r_decrypt(void* self, struct RustStr ciphertext);


// File automatically generated by swift-bridge.
#include <stdbool.h>
typedef struct RRecordCiphertext RRecordCiphertext;
void __swift_bridge__$RRecordCiphertext$_free(void* self);

void* __swift_bridge__$Vec_RRecordCiphertext$new(void);
void __swift_bridge__$Vec_RRecordCiphertext$drop(void* vec_ptr);
void __swift_bridge__$Vec_RRecordCiphertext$push(void* vec_ptr, void* item_ptr);
void* __swift_bridge__$Vec_RRecordCiphertext$pop(void* vec_ptr);
void* __swift_bridge__$Vec_RRecordCiphertext$get(void* vec_ptr, uintptr_t index);
void* __swift_bridge__$Vec_RRecordCiphertext$get_mut(void* vec_ptr, uintptr_t index);
uintptr_t __swift_bridge__$Vec_RRecordCiphertext$len(void* vec_ptr);
void* __swift_bridge__$Vec_RRecordCiphertext$as_ptr(void* vec_ptr);

void* __swift_bridge__$RRecordCiphertext$r_from(struct RustStr string);
void* __swift_bridge__$RRecordCiphertext$r_to_string(void* self);
void* __swift_bridge__$RRecordCiphertext$r_decrypt(void* self, void* view_key);
bool __swift_bridge__$RRecordCiphertext$r_is_owner(void* self, void* view_key);


// File automatically generated by swift-bridge.
#include <stdint.h>
typedef struct RRecordPlaintext RRecordPlaintext;
void __swift_bridge__$RRecordPlaintext$_free(void* self);

void* __swift_bridge__$Vec_RRecordPlaintext$new(void);
void __swift_bridge__$Vec_RRecordPlaintext$drop(void* vec_ptr);
void __swift_bridge__$Vec_RRecordPlaintext$push(void* vec_ptr, void* item_ptr);
void* __swift_bridge__$Vec_RRecordPlaintext$pop(void* vec_ptr);
void* __swift_bridge__$Vec_RRecordPlaintext$get(void* vec_ptr, uintptr_t index);
void* __swift_bridge__$Vec_RRecordPlaintext$get_mut(void* vec_ptr, uintptr_t index);
uintptr_t __swift_bridge__$Vec_RRecordPlaintext$len(void* vec_ptr);
void* __swift_bridge__$Vec_RRecordPlaintext$as_ptr(void* vec_ptr);

void* __swift_bridge__$RRecordPlaintext$r_from_string(struct RustStr string);
void* __swift_bridge__$RRecordPlaintext$r_to_string(void* self);
uint64_t __swift_bridge__$RRecordPlaintext$r_microcredits(void* self);
void* __swift_bridge__$RRecordPlaintext$r_nonce(void* self);
void* __swift_bridge__$RRecordPlaintext$r_serial_number_string(void* self, void* private_key, struct RustStr program_id, struct RustStr record_name);
void* __swift_bridge__$RRecordPlaintext$r_commitment(void* self, struct RustStr program_id, struct RustStr record_name);


// File automatically generated by swift-bridge.
#include <stdint.h>
#include <stdbool.h>
bool __swift_bridge__$RProvingKey$_partial_eq(void* lhs, void* rhs);
typedef struct RProvingKey RProvingKey;
void __swift_bridge__$RProvingKey$_free(void* self);

void* __swift_bridge__$Vec_RProvingKey$new(void);
void __swift_bridge__$Vec_RProvingKey$drop(void* vec_ptr);
void __swift_bridge__$Vec_RProvingKey$push(void* vec_ptr, void* item_ptr);
void* __swift_bridge__$Vec_RProvingKey$pop(void* vec_ptr);
void* __swift_bridge__$Vec_RProvingKey$get(void* vec_ptr, uintptr_t index);
void* __swift_bridge__$Vec_RProvingKey$get_mut(void* vec_ptr, uintptr_t index);
uintptr_t __swift_bridge__$Vec_RProvingKey$len(void* vec_ptr);
void* __swift_bridge__$Vec_RProvingKey$as_ptr(void* vec_ptr);

void* __swift_bridge__$RProvingKey$r_from_bytes(struct __private__FfiSlice bytes);
void* __swift_bridge__$RProvingKey$r_from_string(struct RustStr string);
void* __swift_bridge__$RProvingKey$r_to_bytes(void* self);
void* __swift_bridge__$RProvingKey$r_to_string(void* self);
void* __swift_bridge__$RProvingKey$r_copy(void* self);
bool __swift_bridge__$RProvingKey$r_is_bond_public_prover(void* self);
bool __swift_bridge__$RProvingKey$r_is_claim_unbond_public_prover(void* self);
bool __swift_bridge__$RProvingKey$r_is_fee_private_prover(void* self);
bool __swift_bridge__$RProvingKey$r_is_fee_public_prover(void* self);
bool __swift_bridge__$RProvingKey$r_is_inclusion_prover(void* self);
bool __swift_bridge__$RProvingKey$r_is_join_prover(void* self);
bool __swift_bridge__$RProvingKey$r_is_set_validator_state_prover(void* self);
bool __swift_bridge__$RProvingKey$r_is_split_prover(void* self);
bool __swift_bridge__$RProvingKey$r_is_transfer_private_prover(void* self);
bool __swift_bridge__$RProvingKey$r_is_transfer_private_to_public_prover(void* self);
bool __swift_bridge__$RProvingKey$r_is_transfer_public_prover(void* self);
bool __swift_bridge__$RProvingKey$r_is_transfer_public_to_private_prover(void* self);
bool __swift_bridge__$RProvingKey$r_is_unbond_delegator_as_validator_prover(void* self);
bool __swift_bridge__$RProvingKey$r_is_unbond_public_prover(void* self);


// File automatically generated by swift-bridge.
#include <stdint.h>
#include <stdbool.h>
bool __swift_bridge__$RVerifyingKey$_partial_eq(void* lhs, void* rhs);
typedef struct RVerifyingKey RVerifyingKey;
void __swift_bridge__$RVerifyingKey$_free(void* self);

void* __swift_bridge__$Vec_RVerifyingKey$new(void);
void __swift_bridge__$Vec_RVerifyingKey$drop(void* vec_ptr);
void __swift_bridge__$Vec_RVerifyingKey$push(void* vec_ptr, void* item_ptr);
void* __swift_bridge__$Vec_RVerifyingKey$pop(void* vec_ptr);
void* __swift_bridge__$Vec_RVerifyingKey$get(void* vec_ptr, uintptr_t index);
void* __swift_bridge__$Vec_RVerifyingKey$get_mut(void* vec_ptr, uintptr_t index);
uintptr_t __swift_bridge__$Vec_RVerifyingKey$len(void* vec_ptr);
void* __swift_bridge__$Vec_RVerifyingKey$as_ptr(void* vec_ptr);

void* __swift_bridge__$RVerifyingKey$r_from_bytes(struct __private__FfiSlice bytes);
void* __swift_bridge__$RVerifyingKey$r_to_bytes(void* self);
void* __swift_bridge__$RVerifyingKey$r_from_string(struct RustStr string);
void* __swift_bridge__$RVerifyingKey$r_to_string(void* self);
void* __swift_bridge__$RVerifyingKey$r_copy(void* self);
void* __swift_bridge__$RVerifyingKey$r_bond_public_verifier(void);
void* __swift_bridge__$RVerifyingKey$r_claim_unbond_public_verifier(void);
void* __swift_bridge__$RVerifyingKey$r_fee_private_verifier(void);
void* __swift_bridge__$RVerifyingKey$r_fee_public_verifier(void);
void* __swift_bridge__$RVerifyingKey$r_inclusion_verifier(void);
void* __swift_bridge__$RVerifyingKey$r_join_verifier(void);
void* __swift_bridge__$RVerifyingKey$r_set_validator_state_verifier(void);
void* __swift_bridge__$RVerifyingKey$r_split_verifier(void);
void* __swift_bridge__$RVerifyingKey$r_transfer_private_verifier(void);
void* __swift_bridge__$RVerifyingKey$r_transfer_private_to_public_verifier(void);
void* __swift_bridge__$RVerifyingKey$r_transfer_public_verifier(void);
void* __swift_bridge__$RVerifyingKey$r_transfer_public_to_private_verifier(void);
void* __swift_bridge__$RVerifyingKey$r_unbond_delegator_as_validator_verifier(void);
void* __swift_bridge__$RVerifyingKey$r_unbond_public_verifier(void);
bool __swift_bridge__$RVerifyingKey$r_is_bond_public_verifier(void* self);
bool __swift_bridge__$RVerifyingKey$r_is_claim_unbond_public_verifier(void* self);
bool __swift_bridge__$RVerifyingKey$r_is_fee_private_verifier(void* self);
bool __swift_bridge__$RVerifyingKey$r_is_fee_public_verifier(void* self);
bool __swift_bridge__$RVerifyingKey$r_is_inclusion_verifier(void* self);
bool __swift_bridge__$RVerifyingKey$r_is_join_verifier(void* self);
bool __swift_bridge__$RVerifyingKey$r_is_set_validator_state_verifier(void* self);
bool __swift_bridge__$RVerifyingKey$r_is_split_verifier(void* self);
bool __swift_bridge__$RVerifyingKey$r_is_transfer_private_verifier(void* self);
bool __swift_bridge__$RVerifyingKey$r_is_transfer_private_to_public_verifier(void* self);
bool __swift_bridge__$RVerifyingKey$r_is_transfer_public_verifier(void* self);
bool __swift_bridge__$RVerifyingKey$r_is_transfer_public_to_private_verifier(void* self);
bool __swift_bridge__$RVerifyingKey$r_is_unbond_delegator_as_validator_verifier(void* self);
bool __swift_bridge__$RVerifyingKey$r_is_unbond_public_verifier(void* self);


// File automatically generated by swift-bridge.
#include <stdint.h>
#include <stdbool.h>
bool __swift_bridge__$RTransaction$_partial_eq(void* lhs, void* rhs);
typedef struct RTransaction RTransaction;
void __swift_bridge__$RTransaction$_free(void* self);

void* __swift_bridge__$Vec_RTransaction$new(void);
void __swift_bridge__$Vec_RTransaction$drop(void* vec_ptr);
void __swift_bridge__$Vec_RTransaction$push(void* vec_ptr, void* item_ptr);
void* __swift_bridge__$Vec_RTransaction$pop(void* vec_ptr);
void* __swift_bridge__$Vec_RTransaction$get(void* vec_ptr, uintptr_t index);
void* __swift_bridge__$Vec_RTransaction$get_mut(void* vec_ptr, uintptr_t index);
uintptr_t __swift_bridge__$Vec_RTransaction$len(void* vec_ptr);
void* __swift_bridge__$Vec_RTransaction$as_ptr(void* vec_ptr);

void* __swift_bridge__$RTransaction$r_from_string(struct RustStr transaction);
void* __swift_bridge__$RTransaction$r_to_string(void* self);
void* __swift_bridge__$RTransaction$r_transaction_id(void* self);
void* __swift_bridge__$RTransaction$r_transaction_type(void* self);


// File automatically generated by swift-bridge.
typedef struct RKeyPair RKeyPair;
void __swift_bridge__$RKeyPair$_free(void* self);

void* __swift_bridge__$Vec_RKeyPair$new(void);
void __swift_bridge__$Vec_RKeyPair$drop(void* vec_ptr);
void __swift_bridge__$Vec_RKeyPair$push(void* vec_ptr, void* item_ptr);
void* __swift_bridge__$Vec_RKeyPair$pop(void* vec_ptr);
void* __swift_bridge__$Vec_RKeyPair$get(void* vec_ptr, uintptr_t index);
void* __swift_bridge__$Vec_RKeyPair$get_mut(void* vec_ptr, uintptr_t index);
uintptr_t __swift_bridge__$Vec_RKeyPair$len(void* vec_ptr);
void* __swift_bridge__$Vec_RKeyPair$as_ptr(void* vec_ptr);

void* __swift_bridge__$RKeyPair$r_new(void* proving_key, void* verifying_key);
void* __swift_bridge__$RKeyPair$r_proving_key(void* self);
void* __swift_bridge__$RKeyPair$r_verifying_key(void* self);


// File automatically generated by swift-bridge.
#include <stdbool.h>
typedef struct RStringMap RStringMap;
void __swift_bridge__$RStringMap$_free(void* self);

void* __swift_bridge__$Vec_RStringMap$new(void);
void __swift_bridge__$Vec_RStringMap$drop(void* vec_ptr);
void __swift_bridge__$Vec_RStringMap$push(void* vec_ptr, void* item_ptr);
void* __swift_bridge__$Vec_RStringMap$pop(void* vec_ptr);
void* __swift_bridge__$Vec_RStringMap$get(void* vec_ptr, uintptr_t index);
void* __swift_bridge__$Vec_RStringMap$get_mut(void* vec_ptr, uintptr_t index);
uintptr_t __swift_bridge__$Vec_RStringMap$len(void* vec_ptr);
void* __swift_bridge__$Vec_RStringMap$as_ptr(void* vec_ptr);

void* __swift_bridge__$RStringMap$r_new(void);
struct RustStr __swift_bridge__$RStringMap$r_get(void* self, struct RustStr key);
void* __swift_bridge__$RStringMap$r_insert(void* self, void* key, void* value);
bool __swift_bridge__$RStringMap$r_contains_key(void* self, struct RustStr key);
struct RustStr __swift_bridge__$RStringMap$r_change_or_insert(void* self, void* key, void* new_value);


// File automatically generated by swift-bridge.
#include <stdint.h>
typedef struct RProgramManager RProgramManager;
void __swift_bridge__$RProgramManager$_free(void* self);

void* __swift_bridge__$Vec_RProgramManager$new(void);
void __swift_bridge__$Vec_RProgramManager$drop(void* vec_ptr);
void __swift_bridge__$Vec_RProgramManager$push(void* vec_ptr, void* item_ptr);
void* __swift_bridge__$Vec_RProgramManager$pop(void* vec_ptr);
void* __swift_bridge__$Vec_RProgramManager$get(void* vec_ptr, uintptr_t index);
void* __swift_bridge__$Vec_RProgramManager$get_mut(void* vec_ptr, uintptr_t index);
uintptr_t __swift_bridge__$Vec_RProgramManager$len(void* vec_ptr);
void* __swift_bridge__$Vec_RProgramManager$as_ptr(void* vec_ptr);

void* __swift_bridge__$RProgramManager$r_execute(void* private_key, struct RustStr program, struct RustStr function, void* inputs, double fee_credits, void* fee_record, void* url, void* imports, void* proving_key, void* verifying_key, void* fee_proving_key, void* fee_verifying_key);


