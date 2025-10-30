//
//  Resource.swift
//
//
//  Created by Alexander Pozakshin on 04.12.2023.
//

import Foundation

public struct Resource<T> {
    public enum Kind {
        case metha
        case array
        case raw
    }

    let request: URLRequest

    var kind: Kind
    
    var handlers: (
        metha: (Data) throws -> T,
        array: (Data) throws -> [T],
        raw: (Data) -> Data
    )
}

public extension Resource where T: Decodable & DecoderProvider {
    init(request: URLRequest, as kind: Kind) {
        self.request = request
        self.kind = kind
        self.handlers.metha = {
            let result: T
            do {
                result = try T.decoder().decode(T.self, from: $0)
            } catch let error {
                throw error
            }
            return result
        }
        self.handlers.array = {
            let result: [T]
            do {
                result = try T.decoder().decode([T].self, from: $0)
            } catch let error {
                throw error
            }
            return result
        }
        self.handlers.raw = { $0 }
    }
}
