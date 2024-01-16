//
//  NetworkKeyProvider.swift
//
//
//  Created by Nafeh Shoaib on 11/08/23.
//

import Foundation
import Observation

public typealias FunctionKeyPair = (ProvingKey, VerifyingKey)
public typealias CachedKeyPair = ([UInt8], [UInt8])

public protocol FunctionKeyProvider {
    func bondPublicKeys() async throws -> FunctionKeyPair
    func cacheKeys(keyID: URL, keys: FunctionKeyPair)
    func claimUnbondPublicKeys() async throws -> FunctionKeyPair
    func functionKeys(proverURL: URL, verifierURL: URL, cacheKey: URL?) async throws -> FunctionKeyPair
    func functionKeys(cacheKey: URL) async throws -> FunctionKeyPair
    func feePrivateKeys() async throws -> FunctionKeyPair
    func feePublicKeys() async throws -> FunctionKeyPair
    func joinKeys() async throws -> FunctionKeyPair
    func splitKeys() async throws -> FunctionKeyPair
    func transferKeys(visibility: String) async throws -> FunctionKeyPair
    func unbondPublicKeys() async throws -> FunctionKeyPair
}

@Observable
public class NetworkKeyProvider: FunctionKeyProvider {
    var cache: [URL: CachedKeyPair]
    var cacheOption: Bool
    var keyURIs: String
    
    public static var keyStoreURI = "https://testnet3.parameters.aleo.org/"
    
    public init(cache: [URL : CachedKeyPair], cacheOption: Bool, keyURIs: String) {
        self.cache = cache
        self.cacheOption = cacheOption
        self.keyURIs = keyURIs
    }
    
    public convenience init() {
        self.init(cache: [:], cacheOption: false, keyURIs: NetworkKeyProvider.keyStoreURI)
    }
    
    public func fetchBytes(url: URL) async throws -> [UInt8] {
        let (data, _) = try await URLSession.shared.data(from: url)
        
        return try JSONDecoder().decode([UInt8].self, from: data)
    }
    
    public func useCache() -> Self {
        var s = self
        s.cacheOption = true
        return s
    }
    
    public func clearCache() {
        cache.removeAll()
    }
    
    public func contains(keyID: URL) -> Bool {
        cache.contains(where: { $0.key == keyID })
    }
    
    public func delete(keyID: URL) -> Bool {
        let value = cache.removeValue(forKey: keyID)
        return value != nil
    }
    
    public func getKeys(keyID: URL) throws -> FunctionKeyPair {
        guard let cachedKeys = cache[keyID] else {
            throw KeyProviderError.keyNotFound
        }
        
        let (pkBytes, vkBytes) = cachedKeys
        
        guard let provingKey = ProvingKey(fromBytes: pkBytes),
              let verifyingKey = VerifyingKey(fromBytes: vkBytes) else {
            throw KeyProviderError.invalidBytesForKeys
        }
        
        return (provingKey, verifyingKey)
    }
    
    public func bondPublicKeys() async throws -> FunctionKeyPair {
        try await fetchKeys(for: .bondPublic)
    }
    
    public func cacheKeys(keyID: URL, keys: FunctionKeyPair) {
        let (provingKey, verifyingKey) = keys
        
        guard let pkBytes = provingKey.toBytes(),
              let vkBytes = verifyingKey.toBytes() else {
            return
        }
        
        cache[keyID] = (pkBytes, vkBytes)
    }
    
    public func claimUnbondPublicKeys() async throws -> FunctionKeyPair {
        try await fetchKeys(for: .claimUnbondPublic)
    }
    
    public func functionKeys(proverURL: URL, verifierURL: URL, cacheKey: URL?) async throws -> FunctionKeyPair {
        try await fetchKeys(proverURL: proverURL, verifierURL: verifierURL, cacheKey: cacheKey)
    }
    
    public func functionKeys(cacheKey: URL) throws -> FunctionKeyPair {
        try getKeys(keyID: cacheKey)
    }
    
    public func fetchKeys(proverURL: URL, verifierURL: URL, cacheKey: URL?) async throws -> FunctionKeyPair {
        let cacheKey = cacheKey ?? proverURL
        
        if cacheOption,
           let (pkBytes, vkBytes) = cache[cacheKey] {
            guard let provingKey = ProvingKey(fromBytes: pkBytes),
                  let verifyingKey = VerifyingKey(fromBytes: vkBytes) else {
                throw KeyProviderError.invalidBytesForKeys
            }
            
            return (provingKey, verifyingKey)
        }
        
        let pkBytes = try await fetchBytes(url: proverURL)
        let vkBytes = try await fetchBytes(url: verifierURL)
        
        guard let provingKey = ProvingKey(fromBytes: pkBytes),
              let verifyingKey = VerifyingKey(fromBytes: vkBytes) else {
            throw KeyProviderError.invalidBytesForKeys
        }
        
        if cacheOption {
            cache[cacheKey] = (pkBytes, vkBytes)
        }
        
        return (provingKey, verifyingKey)
    }
    
    public func feePrivateKeys() async throws -> FunctionKeyPair {
        try await fetchKeys(for: .feePrivate)
    }
    
    public func feePublicKeys() async throws -> FunctionKeyPair {
        try await fetchKeys(for: .feePublic)
    }
    
    public func joinKeys() async throws -> FunctionKeyPair {
        try await fetchKeys(for: .join)
    }
    
    public func splitKeys() async throws -> FunctionKeyPair {
        try await fetchKeys(for: .split)
    }
    
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
    
    internal func fetchKeys(for creditProgramKeys: CreditProgramKeys) async throws -> FunctionKeyPair {
        guard let proverURL = URL(string: creditProgramKeys.prover),
              let verifierURL = URL(string: creditProgramKeys.verifier) else {
            throw KeyProviderError.cannotFindKnownKeys
        }
        
        return try await fetchKeys(proverURL: proverURL, verifierURL: verifierURL, cacheKey: URL(string: creditProgramKeys.locator))
    }
    
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
