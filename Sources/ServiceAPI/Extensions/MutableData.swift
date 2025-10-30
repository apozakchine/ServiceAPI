//
//  MutableData.swift
//  APIKit
//
//  Created by Alexander Pozakshin on 09.06.2024.
//

import Foundation

public extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}
