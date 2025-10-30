//
//  String.swift
//  APIKit
//
//  Created by Alexander Pozakshin on 23.02.2024.
//

import Foundation

public extension String {
    var replacingPlusWithQueryAcceptable: String {
        return replacingOccurrences(of: "+", with: "%2B")
    }
    
    func localized(comment: String = "") -> String {
        NSLocalizedString(self, comment: comment)
    }
    
    func localized(arraySeparatedBy separator: String = "@") -> [String] {
        return localized().components(separatedBy: separator)
    }
    
    func localizedWithFormat(_ arguments: [CVarArg]) -> String {
        return String(format: localized(), arguments: arguments)
    }
    
    func localizedArray(at index: Int) -> String? {
        let array = self.localized().components(separatedBy: "@")
        guard array.indices.contains( index ) else { return nil }
        return array[index]
    }
    
    func localizeEnumeration(_ value: Int) -> String {
        return String.localizedStringWithFormat(self.localized(), value)
    }
}
