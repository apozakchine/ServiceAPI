//
//  URLRequest+Headers.swift
//  APIKit
//
//  Created by Alexander Pozakshin on 23.02.2024.
//

import Foundation

public extension URLRequest {
    mutating func add(headers: [HTTP.Header:String]) {
        headers.keys.forEach({
            if let value = headers[$0] {
                setValue(value, forHTTPHeaderField: $0.rawValue)
            }
        })
    }
}
