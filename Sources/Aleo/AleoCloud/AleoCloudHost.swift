//
//  AleoCloudHost.swift
//
//
//  Created by Nafeh Shoaib on 11/08/23.
//

import Foundation

import SwiftCloud

public enum AleoCloudHost: CloudServerURL {
    case testnet3, custom(String)
    
    public var urlString: String {
        switch self {
        case .testnet3:
            return "https://api.explorer.aleo.org/v1"
        case .custom(let string):
            return string
        }
    }
}
