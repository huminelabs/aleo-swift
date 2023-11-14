//
//  AleoCloudClient.swift
//
//
//  Created by Nafeh Shoaib on 11/12/23.
//

import Foundation
import SwiftUI
import Observation

import SwiftCloud

@Observable
public class AleoCloudClient: CloudService<AleoCloudHost, AleoCloudPath> {
    
    var account: Account?
    
    public func set(account: Account) {
        self.account = account
    }
}
