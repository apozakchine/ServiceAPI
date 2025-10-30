//
//  CaseIterableDefault.swift
//  APIKit
//
//  Created by Alexander Pozakshin on 19.06.2024.
//

import Foundation

public protocol CaseIterableDefault: Decodable & CaseIterable & RawRepresentable
       where RawValue: Decodable, AllCases: BidirectionalCollection {
    
    static var `default`: Self { get }
    
}

extension CaseIterableDefault {
    
    public init(from decoder: Decoder) throws {
        self = try Self(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? Self.default
    }
    
}
