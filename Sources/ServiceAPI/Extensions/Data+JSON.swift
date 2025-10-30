//
//  Data+JSON.swift
//  
//
//  Created by Alexander Pozakshin on 27.12.2023.
//

import Foundation

extension Data: CoderProvider {
    func json() -> [String:Any]? {
        if let theJSONData = try? JSONSerialization.jsonObject(with: self, options: []) as? NSDictionary {
            var swiftDict: [String:Any] = [:]
            for key in theJSONData.allKeys {
                let stringKey = key as? String
                if let key = stringKey, let keyValue = theJSONData.value(forKey: key) {
                    swiftDict[key] = keyValue
                }
            }
            return swiftDict
        }
        return nil
    }
}

public extension Dictionary {
    func prettyPrinted() -> String? {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted),
              let string = String(data: jsonData, encoding: .ascii) else {
            return nil
        }
        return string
    }
}
