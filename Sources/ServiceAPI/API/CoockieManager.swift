//
//  CookieManager.swift
//  
//
//  Created by Alexander Pozakshin on 04.12.2023.
//

import Foundation

public class CookieManager {
    
    nonisolated(unsafe) public static let shared = CookieManager()
    
    private let storage = HTTPCookieStorage.shared
    
    private init() {}
    
    var get: [HTTPCookie]? { storage.cookies }
    
    func save(response: URLResponse) {
        guard let response = response as? HTTPURLResponse,
              let url = response.url,
              let fields = response.allHeaderFields as? [String:String] else {
            return
        }
        let cookies = HTTPCookie.cookies(withResponseHeaderFields: fields, for: url)
        storage.setCookies(cookies, for: response.url!, mainDocumentURL: nil)
        cookies.forEach {
            var properties = [HTTPCookiePropertyKey:Any]()
            properties[.name] = $0.name as AnyObject
            properties[.value] = $0.value as AnyObject
            properties[.domain] = $0.domain as AnyObject
            properties[.path] = $0.path as AnyObject
            properties[.version] = NSNumber(value: $0.version)
            properties[.expires] = NSDate().addingTimeInterval(31536000.0)
            
            if let newCookie = HTTPCookie(properties: properties) {
                storage.setCookie(newCookie)
            }
        }
    }
    
    func removeAll() {
        storage.cookies?
            .compactMap{$0}
            .forEach { storage.deleteCookie($0) }
    }
    
}
