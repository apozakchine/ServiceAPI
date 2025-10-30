//
//  File.swift
//  
//
//  Created by Alexander Pozakshin on 04.12.2023.
//

import UIKit

public extension String {
    
    nonisolated(unsafe) static var enEN: String = "en-EN"
    
    nonisolated(unsafe) static var noCache: String = "no-cache"
    
    nonisolated(unsafe) static var applicationJSON: String = "application/json"
    
    nonisolated(unsafe) static var applicationFormURLEncoded: String = "application/x-www-form-urlencoded"
    
    static func formDataWith(boundary: String) -> String {
        return "multipart/form-data; boundary=\(boundary)"
    }
    
}

public extension Endpoint {
    
    var url: URL? {
        guard let string = "\(serverURL)\(path)"
            .addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
            return nil
        }
        return URL(string: string)
    }
    
    var defaultHeaders: [HTTP.Header:String] {
        return [:]
    }

    var defaultQueryItems: [URLQueryItem] {
        return []
    }

    var interval: TimeInterval {
        return 10.0
    }
    
    var shouldLogRequest: Bool {
        return false
    }
    
    var shouldLogResponse: Bool {
        return false
    }
    
    var language: String {
        guard let preferredLaunguage = Locale.preferredLanguages.first else {
            return .enEN
        }
        return preferredLaunguage as String
    }
    
    var userAgent: String {
        return ""
    }
    
    
}

// MARK: String Conversion
public extension Endpoint {
    
    func string(from authenticate: Autenticate) -> String? {
        switch authenticate {
        case let .token(value):
            return "Bearer \(value)"
        case let .some(string):
            return string
        case .none:
            return nil
        }
    }
    
    func string<T: Encodable & EncoderProvider>(from instance: T) -> String? {
        guard let data = try? T.encoder().encode(instance) else {
            return nil
        }
        guard let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any] else {
            return nil
        }
        return string(from: dictionary)
    }

    func string(from dictionary: [String:Any]) -> String {
        var data = [String]()
        for(key, value) in dictionary {
            data.append(key + "=\(value)")
        }
        return data.map { String($0) }.joined(separator: "&")
    }

}

// MARK: Custom
public extension Endpoint {
    
    func boundary() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
    func body(from dictionary: [String:Any]) -> Data? {
        guard let data = try? JSONSerialization.data(withJSONObject: dictionary) else {
            return nil
        }
        return data
    }
    
    func png(from data: Data, named: String = "image") -> File {
        return .init(mime: .png, data: data, named: named)
    }
    
}

// MARK: - Request Constructors
public extension Endpoint {
    
    func empty(autenticate: Autenticate = .none) -> URLRequest {
        guard let url = url else {
            return empty(autenticate: autenticate)
        }
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: interval)
        request.httpMethod = method.description
        if let string = string(from: autenticate) {
            request.add(headers: [.authorization: string])
        }
        request.add(headers: defaultHeaders)
        return request
    }
    
    func post<T: Codable & CoderProvider>(from instance: T,
                                          encoding: ParameterEncoding = .json,
                                          autenticate: Autenticate = .none,
                                          headers: [HTTP.Header:String] = [.contentType: .applicationJSON]) -> URLRequest
    {
        switch encoding {
        case .json:
            guard let parameters = try? JSONSerialization
                .jsonObject(with: T.self.encoder().encode(instance)) as? [String:Any] else {
                return empty(autenticate: autenticate)
            }
            return post(parameters: parameters, autenticate: autenticate, headers: headers)
        case .string:
            guard let parameters = try? JSONSerialization
                .jsonObject(with: T.self.encoder().encode(instance)) as? [String:Any] else {
                return empty(autenticate: autenticate)
            }
            return post(parameters: string(from: parameters), autenticate: autenticate, headers: headers)
        case .data:
            guard let json = try? JSONSerialization.jsonObject(with: T.self.encoder().encode(instance)) else {
                return empty(autenticate: autenticate)
            }
            guard let data = try? JSONSerialization.data(withJSONObject: json) else {
                return empty(autenticate: autenticate)
            }
            guard let string = String(data: data, encoding: .utf8) else {
                return empty(autenticate: autenticate)
            }
            return post(parameters: string, autenticate: autenticate, headers: headers)
        }
    }
    
    func get<T: Codable & CoderProvider>(from instance: T,
                                         encoding: ParameterEncoding = .json,
                                         autenticate: Autenticate = .none,
                                         headers: [HTTP.Header:String] = [:]) -> URLRequest
    {
            guard let parameters = try? JSONSerialization
                .jsonObject(with: T.self.encoder().encode(instance)) as? [String:Any] else {
                return empty(autenticate: autenticate)
            }
            return get(with: parameters, autenticate: autenticate, headers: headers)
    }
    
}

private extension Endpoint {
    
    func queryItems(dictionary: [String:Any]) -> [URLQueryItem] {
        var items = [URLQueryItem]()
        dictionary.keys.forEach({
            if let value = dictionary[$0], value is Array<Any> {
                let array: Array<Any> = value as! [Any]
                items.append(URLQueryItem(name: $0, value: array.compactMap({"\($0)"}).joined(separator: ",")))
            } else if let value = dictionary[$0] {
                items.append(URLQueryItem(name: $0, value: "\(value)"))
            }
        })
        return items
    }
    
    func get(with parameters: [String:Any],
             autenticate: Autenticate = .none,
             headers: [HTTP.Header:String] = [:]) -> URLRequest
    {
        guard let url = url else {
            return empty(autenticate: autenticate)
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = queryItems(dictionary: parameters)
        
        if defaultQueryItems.isEmpty == false {
            components?.queryItems?.append(contentsOf: defaultQueryItems)
        }
        
        guard let queryURL = URL(string: components?.url?.absoluteString ?? "") else {
            return empty(autenticate: autenticate)
        }

        var request = URLRequest(url: queryURL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: interval)
        request.httpMethod = method.description
        if let string = string(from: autenticate) {
            request.add(headers: [.authorization: string])
        }
        request.add(headers: defaultHeaders)
        return request
    }

}

private extension Endpoint {
    
    func post(parameters: [String:Any],
              autenticate: Autenticate = .none,
              headers: [HTTP.Header:String] = [:]) -> URLRequest
    {
        guard let url = url else {
            return empty(autenticate: autenticate)
        }
        var request: URLRequest
        if defaultQueryItems.isEmpty == false {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.queryItems = defaultQueryItems
            guard let queryURL = URL(string: components?.url?.absoluteString ?? "") else {
                return empty(autenticate: autenticate)
            }
            request = URLRequest(url: queryURL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: interval)
        } else {
            request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: interval)
        }
        request.httpMethod = method.description
        if let data = try? JSONSerialization.data(withJSONObject: parameters, options: []) {
            request.httpBody = data
        }
        if let string = string(from: autenticate) {
            request.add(headers: [.authorization: string])
        }
        request.add(headers: defaultHeaders)
        return request
    }
    
    func post(parameters: String,
              autenticate: Autenticate = .none,
              headers: [HTTP.Header:String] = [:]) -> URLRequest
    {
        guard let url = url else {
            return empty(autenticate: autenticate)
        }
        var request: URLRequest
        if defaultQueryItems.isEmpty == false {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.queryItems = defaultQueryItems
            guard let queryURL = URL(string: components?.url?.absoluteString ?? "") else {
                return empty(autenticate: autenticate)
            }
            request = URLRequest(url: queryURL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: interval)
        } else {
            request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: interval)
        }
        request.httpMethod = method.description
        request.httpBody = parameters.data(using: .utf8) ?? Data()
        if let string = string(from: autenticate) {
            request.add(headers: [.authorization: string])
        }
        request.add(headers: defaultHeaders)
        return request
    }

}
