//
//  NetworkError.swift
//
//
//  Created by Nafeh Shoaib on 11/08/23.
//

import Foundation

import SwiftCloud

public enum NetworkError: Error, LocalizedError {
    case startHeightLessThanZero, cannotParsePrivateKey, privateKeyNotFound, heightError
    
    public var errorDescription: String? {
        switch self {
        case .startHeightLessThanZero:
            return "Start height must be greater than or equal to 0"
        case .cannotParsePrivateKey:
            return "Error parsing private key provided."
        case .privateKeyNotFound:
            return "Private key must be specified as an argument or set in the AleoCloudClient"
        case .heightError:
            return "Start height must be less than or equal to end height."
        }
    }
}
