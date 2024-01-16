//
//  RStringMap.swift
//
//
//  Created by Nafeh Shoaib on 11/28/23.
//

import Foundation

extension RStringMap {
    typealias Key = String
    
    typealias Value = String
    
    convenience init(dictionaryLiteral elements: [String: String]) {
        self.init()
        
        for (key, value) in elements {
            let _ = r_insert(key, value)
        }
    }
}
