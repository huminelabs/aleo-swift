//
//  KeyProvider.swift
//  
//
//  Created by Nafeh Shoaib on 12/7/23.
//

import Foundation

public typealias FunctionKeyPair = (ProvingKey, VerifyingKey)
public typealias CachedKeyPair = ([UInt8], [UInt8])

/**
 * KeyProvider interface. Enables the retrieval of public proving and verifying keys for Aleo Programs.
 */
public protocol KeyProvider {
    /**
     * Get `bond_public` function keys from the credits.aleo program
     *
     * - Returns: Proving and verifying keys for the `bond_public` function
     */
    func bondPublicKeys() async throws -> FunctionKeyPair
    
    /**
     * Cache a set of keys. This will overwrite any existing keys with the same keyId. The user can check if a keyId
     * exists in the cache using the containsKeys method prior to calling this method if overwriting is not desired.
     *
     * - Parameter keyID: access key for the cache
     * - Parameter keys: keys to cache
     */
    func cacheKeys(keyID: String, keys: FunctionKeyPair) throws
    
    /**
     * Get `unbond_public` function keys from the credits.aleo program
     *
     * - Returns: Proving and verifying keys for the `unbond_public` function
     */
    func claimUnbondPublicKeys() async throws -> FunctionKeyPair
    
    /**
     * Get arbitrary function keys from a provider
     *
     * - Parameters:
     *      - proverURL:  Optional search parameter for the key provider
     *      - verifierURL:  Optional search parameter for the key provider
     *      - cacheKey:  Optional search parameter for the key provider
     * - Returns: Proving and verifying keys for the specified program
     *
     * ```javascript
     * // Create a search object which implements the KeySearchParams interface
     * class IndexDbSearch implements KeySearchParams {
     *     db: string
     *     keyId: string
     *     constructor(params: {db: string, keyId: string}) {
     *         this.db = params.db;
     *         this.keyId = params.keyId;
     *     }
     * }
     *
     * // Create a new object which implements the KeyProvider interface
     * class IndexDbKeyProvider implements FunctionKeyProvider {
     *     async functionKeys(params: KeySearchParams): Promise<FunctionKeyPair | Error> {
     *         return new Promise((resolve, reject) => {
     *             const request = indexedDB.open(params.db, 1);
     *
     *             request.onupgradeneeded = function(e) {
     *                 const db = e.target.result;
     *                 if (!db.objectStoreNames.contains('keys')) {
     *                     db.createObjectStore('keys', { keyPath: 'id' });
     *                 }
     *             };
     *
     *             request.onsuccess = function(e) {
     *                 const db = e.target.result;
     *                 const transaction = db.transaction(["keys"], "readonly");
     *                 const store = transaction.objectStore("keys");
     *                 const request = store.get(params.keyId);
     *                 request.onsuccess = function(e) {
     *                     if (request.result) {
     *                         resolve(request.result as FunctionKeyPair);
     *                     } else {
     *                         reject(new Error("Key not found"));
     *                     }
     *                 };
     *                 request.onerror = function(e) { reject(new Error("Error fetching key")); };
     *             };
     *
     *             request.onerror = function(e) { reject(new Error("Error opening database")); };
     *         });
     *     }
     *
     *     // implement the other methods...
     * }
     *
     * const keyProvider = new AleoKeyProvider();
     * const networkClient = new AleoNetworkClient("https://api.explorer.aleo.org/v1");
     * const recordProvider = new NetworkRecordProvider(account, networkClient);
     *
     * // Initialize a program manager with the key provider to automatically fetch keys for value transfers
     * const programManager = new ProgramManager("https://api.explorer.aleo.org/v1", keyProvider, recordProvider);
     * programManager.transfer(1, "aleo166q6ww6688cug7qxwe7nhctjpymydwzy2h7rscfmatqmfwnjvggqcad0at", "public", 0.5)
     *
     * // Keys can also be fetched manually
     * const searchParams = new IndexDbSearch({db: "keys", keyId: "credits.aleo:transferPrivate"});
     * const [transferPrivateProvingKey, transferPrivateVerifyingKey] = await keyProvider.functionKeys(searchParams)
     * ```
     */
    func functionKeys(proverURL: URL?, verifierURL: URL?, cacheKey: String?) async throws -> FunctionKeyPair
    
    /**
     * Get `fee_private` function keys from the credits.aleo program
     *
     * - Returns: Proving and verifying keys for the join function
     */
    func feePrivateKeys() async throws -> FunctionKeyPair
    
    /**
     * Get `fee_public` function keys from the credits.aleo program
     *
     * - Returns: Proving and verifying keys for the join function
     */
    func feePublicKeys() async throws -> FunctionKeyPair
    
    /**
     * Get `join` function keys from the credits.aleo program
     *
     * - Returns: Proving and verifying keys for the join function
     */
    func joinKeys() async throws -> FunctionKeyPair
    
    /**
     * Get `split` function keys from the credits.aleo program
     *
     * - Returns: Proving and verifying keys for the join function
     */
    func splitKeys() async throws -> FunctionKeyPair
    
    /**
     * Get keys for a variant of the transfer function from the credits.aleo program
     *
     * - Parameter visibility: Visibility of the transfer function (private, public, privateToPublic, publicToPrivate)
     * - Returns: Proving and verifying keys for the specified transfer function
     *
     * ```javascript
     * // Create a new object which implements the KeyProvider interface
     * const networkClient = new AleoNetworkClient("https://api.explorer.aleo.org/v1");
     * const keyProvider = new AleoKeyProvider();
     * const recordProvider = new NetworkRecordProvider(account, networkClient);
     *
     * // Initialize a program manager with the key provider to automatically fetch keys for value transfers
     * const programManager = new ProgramManager("https://api.explorer.aleo.org/v1", keyProvider, recordProvider);
     * programManager.transfer(1, "aleo166q6ww6688cug7qxwe7nhctjpymydwzy2h7rscfmatqmfwnjvggqcad0at", "public", 0.5);
     *
     * // Keys can also be fetched manually
     * const [transferPublicProvingKey, transferPublicVerifyingKey] = await keyProvider.transferKeys("public");
     * ```
     */
    func transferKeys(visibility: String) async throws -> FunctionKeyPair
    
    /**
     * Get `unbond_public` function keys from the credits.aleo program
     *
     * - Returns: Proving and verifying keys for the join function
     */
    func unbondPublicKeys() async throws -> FunctionKeyPair
}
