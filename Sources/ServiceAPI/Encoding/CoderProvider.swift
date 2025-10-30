//
//  CoderProvider.swift
//  
//
//  Created by Alexander Pozakshin on 24.11.2023.
//

import Foundation

public protocol CoderProvider: DecoderProvider, EncoderProvider {}

extension Array: CoderProvider {}

public protocol DecoderProvider {
    static func decoder() -> JSONDecoder
}

public protocol EncoderProvider {
    static func encoder() -> JSONEncoder
}

public extension EncoderProvider {
    static func encoder() -> JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(.dateWithMillisecondsISO8601)
        return encoder
    }
}

public extension DecoderProvider {
    static func decoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.dateWithMillisecondsISO8601)
        return decoder
    }
}
