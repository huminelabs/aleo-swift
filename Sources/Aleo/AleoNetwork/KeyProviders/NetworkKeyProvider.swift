//
//  NetworkKeyProvider.swift
//
//
//  Created by Nafeh Shoaib on 11/08/23.
//

import Foundation
import Observation
import KeychainAccess

/**
 * NetworkKeyProvider class. Implements the KeyProvider interface. Enables the retrieval of Aleo program proving and
 * verifying keys for the credits.aleo program over http from official Aleo sources and storing and retrieving function
 * keys from a local memory cache.
 */
@Observable
public class NetworkKeyProvider: KeyProvider {
    private var keychain: Keychain = {
        return Keychain(service: "aleo.networkKeyProvider")
            .synchronizable(false)
    }()
    
    var cacheOption: Bool
    var keyURIs: String
    
    public static var keyStoreURI = "https://testnet3.parameters.aleo.org/"
    
    public init(cacheOption: Bool, keyURIs: String) {
        self.cacheOption = cacheOption
        self.keyURIs = keyURIs
    }
    
    public convenience init() {
        self.init(cacheOption: false, keyURIs: NetworkKeyProvider.keyStoreURI)
    }
    
    public func fetchBytes(url: URL) async throws -> [UInt8] {
        let (data, _) = try await URLSession.shared.data(from: url)
        
        return try JSONDecoder().decode([UInt8].self, from: data)
    }
    
    /**
     * Use local memory to store keys
     *
     * - Returns: the `NetworkKeyProvider` instance with `cacheOption` set to `true`
     */
    public func useCache() -> Self {
        var s = self
        s.cacheOption = true
        return s
    }
    
    /**
     * Clear the key cache
     */
    public func clearCache() throws {
        try keychain.removeAll()
    }
    
    /**
     * Determine if a keyId exists in the cache
     *
     * - Parameter keyID: key ID of a proving and verifying key pair
     * - Returns: true if the keyId exists in the cache, false otherwise
     */
    public func contains(keyID: String) throws -> Bool {
        let doesProvingKeyExist = try keychain.contains(keyID + ".provingKey")
        let doesVerifyingKeyExist = try keychain.contains(keyID + ".verifyingKey")
        
        return doesProvingKeyExist && doesVerifyingKeyExist
    }
    
    /**
     * Delete a set of keys from the cache
     *
     * - Parameter keyID: key ID of a proving and verifying key pair to delete from memory
     */
    public func delete(keyID: String) throws {
        try keychain.remove(keyID + ".provingKey")
        try keychain.remove(keyID + ".verifyingKey")
    }
    
    /**
     * Get a set of keys from the cache
     *
     * - Parameter keyID: key ID of a proving and verifying key pair
     *
     * - Returns: Proving and verifying keys for the specified program
     */
    public func getKeys(keyID: String) throws -> FunctionKeyPair {
        guard let provingKeyString = keychain[keyID + ".provingKey"],
              let verifyingKeyString = keychain[keyID + ".verifyingKey"] else {
            throw KeyProviderError.keyNotFound
        }
        
        guard let provingKey = ProvingKey(provingKeyString),
              let verifyingKey = VerifyingKey(verifyingKeyString) else {
            throw KeyProviderError.invalidBytesForKeys
        }
        
        return (provingKey, verifyingKey)
    }
    
    public func bondPublicKeys() async throws -> FunctionKeyPair {
        try await fetchKeys(for: .bondPublic)
    }
    
    /**
     * Cache a set of keys. This will overwrite any existing keys with the same keyId. The user can check if a keyId
     * exists in the cache using the containsKeys method prior to calling this method if overwriting is not desired.
     *
     * - Parameters:
     *      - keyID: access key for the cache
     *      - keys: keys to cache
     */
    public func cacheKeys(keyID: String, keys: FunctionKeyPair) throws {
        let (provingKey, verifyingKey) = keys
        
        try keychain.set(provingKey.toString(), key: keyID + ".provingKey")
        try keychain.set(verifyingKey.toString(), key: keyID + ".verifyingKey")
    }
    
    public func claimUnbondPublicKeys() async throws -> FunctionKeyPair {
        try await fetchKeys(for: .claimUnbondPublic)
    }
    
    /**
     * Get arbitrary function keys from a provider
     *
     * - Parameters:
     *      - verifierURL: URL of the proving key
     *      - proverURL: URL the verifying key
     *      - cacheKey: Key to store the keys in the cache
     * - Returns: Proving and verifying keys for the specified program
     *
     * Create a new object which implements the `KeyProvider` protocol
     * ```swift
     * let networkClient = NetworkClient("https://api.explorer.aleo.org/v1")
     * let keyProvider = NetworkKeyProvider()
     * let recordProvider = NetworkRecordProvider(account: account, client: networkClient)
     * ```
     *
     * Initialize a program manager with the key provider to automatically fetch keys for value transfers
     * ```swift
     * let programManager = ProgramManager("https://api.explorer.aleo.org/v1", keyProvider: keyProvider, recordProvider: recordProvider);
     * try await programManager.transfer(amount: 1, recipient: "aleo166q6ww6688cug7qxwe7nhctjpymydwzy2h7rscfmatqmfwnjvggqcad0at", transferType: "public", fee: 0.5);
     * ```
     *
     * Keys can also be fetched manually using the key provider
     * ```swift
     * let cacheKey = "myProgram:myFunction"
     * let (transferPrivateProvingKey, transferPrivateVerifyingKey) = try await keyProvider.functionKeys(cacheKey: cacheKey);
     * ```
     */
    public func functionKeys(proverURL: URL?, verifierURL: URL?, cacheKey: String? = nil) async throws -> FunctionKeyPair {
        if let proverURL = proverURL, let verifierURL = verifierURL {
            return try await fetchKeys(proverURL: proverURL, verifierURL: verifierURL, cacheKey: cacheKey)
        } else if let cacheKey = cacheKey {
            return try getKeys(keyID: cacheKey)
        } else {
            // Test
            throw KeyProviderError.cannotFindKnownKeys
        }
    }
    
    /**
     * Returns the proving and verifying keys for a specified program from a specified url.
     *
     * - Parameters:
     *      - verifierURL: URL of the proving key
     *      - proverURL: URL the verifying key
     *      - cacheKey: Key to store the keys in the cache
     * - Returns: Proving and verifying keys for the specified program
     *
     * Create a new `NetworkKeyProvider` object
     * ```swift
     * let networkClient = NetworkClient("https://api.explorer.aleo.org/v1")
     * let keyProvider = NetworkKeyProvider()
     * let recordProvider = NetworkRecordProvider(account: account, client: networkClient)
     * ```
     *
     * Initialize a program manager with the key provider to automatically fetch keys for value transfers
     * ```swift
     * let programManager = ProgramManager("https://vm.aleo.org/api", keyProvider: keyProvider, recordProvider: recordProvider)
     * try await programManager.transfer(amount: 1, recipient: "aleo166q6ww6688cug7qxwe7nhctjpymydwzy2h7rscfmatqmfwnjvggqcad0at", transferType: "public", fee: 0.5)
     * ```
     *
     * Keys can also be fetched manually
     * ```swift
     * let (transferPrivateProvingKey, transferPrivateVerifyingKey) = try await keyProvider.fetchKeys(proverURL: "https://testnet3.parameters.aleo.org/transfer_private.prover.2a9a6f2", verifierURL: "https://testnet3.parameters.aleo.org/transfer_private.verifier.3a59762")
     * ```
     */
    public func fetchKeys(proverURL: URL, verifierURL: URL, cacheKey: String?) async throws -> FunctionKeyPair {
        let cacheKey = cacheKey ?? proverURL.absoluteString
        
        if cacheOption {
            return try getKeys(keyID: cacheKey)
        }
        
        let pkBytes = try await fetchBytes(url: proverURL)
        let vkBytes = try await fetchBytes(url: verifierURL)
        
        guard let provingKey = ProvingKey(fromBytes: pkBytes),
              let verifyingKey = VerifyingKey(fromBytes: vkBytes) else {
            throw KeyProviderError.invalidBytesForKeys
        }
        
        if cacheOption {
            try cacheKeys(keyID: cacheKey, keys: (provingKey, verifyingKey))
        }
        
        return (provingKey, verifyingKey)
    }
    
    /**
     * Returns the proving and verifying keys for the `fee_private` function in the `credits.aleo` program
     *
     * - Returns: Proving and verifying keys for the `fee` function
     */
    public func feePrivateKeys() async throws -> FunctionKeyPair {
        try await fetchKeys(for: .feePrivate)
    }
    
    /**
     * Returns the proving and verifying keys for the `fee_public` function in the `credits.aleo` program
     *
     * - Returns: Proving and verifying keys for the `fee` function
     */
    public func feePublicKeys() async throws -> FunctionKeyPair {
        try await fetchKeys(for: .feePublic)
    }
    
    /**
     * Returns the proving and verifying keys for the `join` function in the `credits.aleo` program
     *
     * - Returns: Proving and verifying keys for the `join` function
     */
    public func joinKeys() async throws -> FunctionKeyPair {
        try await fetchKeys(for: .join)
    }
    
    /**
     * Returns the proving and verifying keys for the `split` function in the `credits.aleo` program
     *
     * - Returns: Proving and verifying keys for the `split` function
     */
    public func splitKeys() async throws -> FunctionKeyPair {
        try await fetchKeys(for: .split)
    }
    
    /**
     * Returns the proving and verifying keys for the `transfer` functions in the `credits.aleo` program
     *
     * - Parameter visibility: Visibility of the `transfer` function
     * - Returns: Proving and verifying keys for the `transfer` function
     *
     *
     * Create a new AleoKeyProvider
     * ```swift
     * let networkClient = NetworkClient("https://vm.aleo.org/api")
     * let keyProvider = NetworkKeyProvider()
     * let recordProvider = NetworkRecordProvider(account: account, client: networkClient)
     * ```
     *
     * Initialize a program manager with the key provider to automatically fetch keys for value transfers
     * ```swift
     * let programManager = ProgramManager("https://vm.aleo.org/api", keyProvider: keyProvider, recordProvider: recordProvider)
     * try await programManager.transfer(amount: 1, recipient: "aleo166q6ww6688cug7qxwe7nhctjpymydwzy2h7rscfmatqmfwnjvggqcad0at", transferType: "public", fee: 0.5)
     * ```
     *
     * Keys can also be fetched manually
     * ```swift
     * let (transferPublicProvingKey, transferPublicVerifyingKey) = try await keyProvider.transferKeys(visibility: "public")
     * ```
     */
    public func transferKeys(visibility: String) async throws -> FunctionKeyPair {
        if CreditProgramKeys.privateTransfer.contains(where: { $0 == visibility }) {
            return try await fetchKeys(for: .transferPrivate)
        } else if CreditProgramKeys.privateToPublicTransfer.contains(where: { $0 == visibility }) {
            return try await fetchKeys(for: .transferPrivateToPublic)
        } else if CreditProgramKeys.publicTransfer.contains(where: { $0 == visibility }) {
            return try await fetchKeys(for: .transferPublic)
        } else if CreditProgramKeys.publicToPrivateTransfer.contains(where: { $0 == visibility }) {
            return try await fetchKeys(for: .transferPublicToPrivate)
        } else {
            throw KeyProviderError.invalidVisibility(visibility)
        }
    }
    
    public func unbondPublicKeys() async throws -> FunctionKeyPair {
        try await fetchKeys(for: .unbondPublic)
    }
    
    /**
     * Returns the proving and verifying keys for a specified program from a specified url.
     *
     * - Parameter creditProgramKeys: known credit program with prover and verifier IDs/URLs
     * - Returns: Proving and verifying keys for the specified program
     *
     * Create a new `NetworkKeyProvider` object
     * ```swift
     * let networkClient = NetworkClient("https://api.explorer.aleo.org/v1")
     * let keyProvider = NetworkKeyProvider()
     * let recordProvider = NetworkRecordProvider(account: account, client: networkClient)
     * ```
     *
     * Initialize a program manager with the key provider to automatically fetch keys for value transfers
     * ```swift
     * let programManager = ProgramManager("https://vm.aleo.org/api", keyProvider: keyProvider, recordProvider: recordProvider)
     * try await programManager.transfer(amount: 1, recipient: "aleo166q6ww6688cug7qxwe7nhctjpymydwzy2h7rscfmatqmfwnjvggqcad0at", transferType: "public", fee: 0.5)
     * ```
     *
     * Keys can also be fetched manually
     * ```swift
     * let (transferPrivateProvingKey, transferPrivateVerifyingKey) = try await keyProvider.fetchKeys(proverURL: "https://testnet3.parameters.aleo.org/transfer_private.prover.2a9a6f2", verifierURL: "https://testnet3.parameters.aleo.org/transfer_private.verifier.3a59762")
     * ```
     */
    internal func fetchKeys(for creditProgramKeys: CreditProgramKeys) async throws -> FunctionKeyPair {
        guard let proverURL = URL(string: creditProgramKeys.prover),
              let verifierURL = URL(string: creditProgramKeys.verifier) else {
            throw KeyProviderError.cannotFindKnownKeys
        }
        
        return try await fetchKeys(proverURL: proverURL, verifierURL: verifierURL, cacheKey: creditProgramKeys.locator)
    }
    
    /**
     * Gets a verifying key. If the verifying key is for a `credits.aleo` function, get it from the cache otherwise
     *
     * - Returns: Verifying key for the function
     */
    public func getVerifyingKey(from verifierURI: String) async throws -> VerifyingKey {
        if let knownVerifyingKey = CreditProgramKeys.from(verifier: verifierURI)?.verifyingKey {
            return knownVerifyingKey
        }
        
        guard let url = URL(string: verifierURI) else {
            throw KeyProviderError.invalidParameters
        }
        
        do {
            let (data, _) =  try await URLSession.shared.data(from: url)
            
            let string = try JSONDecoder().decode(String.self, from: data)
            
            guard let verifyingKey = VerifyingKey(string) else {
                throw KeyProviderError.invalidStringForKey(string)
            }
            
            return verifyingKey
        } catch {
            guard let url = URL(string: verifierURI) else {
                throw KeyProviderError.invalidParameters
            }
            
            let bytes = try await fetchBytes(url: url)
            
            guard let verifyingKey = VerifyingKey(fromBytes: bytes) else {
                throw KeyProviderError.invalidBytesForKeys
            }
            
            return verifyingKey
        }
    }
    
}

enum KeyProviderError: Error, LocalizedError {
    case keyNotFound, invalidBytesForKeys, invalidParameters, invalidStringForKey(String), cannotFindKnownKeys, invalidVisibility(String)
    
    var errorDescription: String? {
        switch self {
        case .keyNotFound:
            "Key not found in cache."
        case .invalidBytesForKeys:
            "Invalid Bytes array for converting to Proving and Verifying Keys."
        case .invalidParameters:
            "Invalid parameters provided, must provide either a cacheKey and/or a proverUrl and a verifierUrl"
        case .invalidStringForKey(let string):
            "Invalid String for key with string: \(string)"
        case .cannotFindKnownKeys:
            "Cannot find keys for known program"
        case .invalidVisibility(let visibility):
            "Invalid visibility type: \(visibility)"
        }
    }
}
