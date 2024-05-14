//
//  AleoViewModel.swift
//  AleoSwiftDemo
//
//  Created by Nafeh Shoaib on 3/18/24.
//

import Foundation
import SwiftUI
import os

import Aleo

@Observable()
class AleoViewModel {
    
    var progress = 0.0
    
    var isLoading = false
    
    func executeHello() async throws {
        Task { @MainActor in
            isLoading = true
            progress = 0
        }
        
        let account = Account(privateKey: PrivateKey("APrivateKey1zkp6XDaWM3PVJrKhJeMjPW9nz6QCRjkZJeBNDHDqLLsWbku")!)
        
        Task { @MainActor in
            progress = 0.3
        }
        
        let programManager = NetworkProgramManager(account: account, host: "https://api.explorer.aleo.org/v1/testnet3", networkClient: NetworkClient(serverURL: .testnet3))
        
        Task { @MainActor in
            progress = 0.7
        }
        
        let response = try await programManager.execute(programName: "hello_hello.aleo", functionName: "hello_hello", fee: 0.020, privateFee: false, inputs: ["5u32", "5u32"], keySearchCacheKey: "hello_hello:hello")
        
        os_log("Successfully executed hello program with response: \(response)")
        
        Task { @MainActor in
            isLoading = false
            progress = 1
        }
    }
}
