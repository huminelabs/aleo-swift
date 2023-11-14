//
//  AleoCloudClient+CloudService.swift
//
//
//  Created by Nafeh Shoaib on 11/12/23.
//

import Foundation

import SwiftCloud

public enum AleoCloudPath: CloudServicePath {
    case custom(String)
    
    public var pathString: String {
        switch self {
        case .custom(let string):
            return string
        }
    }
}
