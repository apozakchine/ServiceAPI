//
//  IsNull.swift
//  APIKit
//
//  Created by Alexander Pozakshin on 14.06.2024.
//

import Foundation

public protocol isNull {
    func isNull() throws -> Bool
}

public extension isNull {
    
    func isNull() throws -> Bool {
        let mirror = Mirror(reflecting: self)
        return mirror.children.contains(where: { $0.value as Any? == nil})
    }
    
}
