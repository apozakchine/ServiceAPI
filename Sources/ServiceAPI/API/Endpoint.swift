//
//  Endpoint.swift
//  
//
//  Created by Alexander Pozakshin on 04.12.2023.
//

import Foundation

public enum Autenticate {
    
    case token(String)
    
    case some(String)
    
    case none
    
}

public enum ParameterEncoding {
    
    case string
    
    case data
    
    case json
    
}

public protocol Endpoint {
    
    var serverURL: String { get }
    
    var defaultHeaders: [HTTP.Header:String] { get }
    
    var defaultQueryItems: [URLQueryItem] { get }
    
    var path: String { get }
    
    var method: HTTP.Method { get }
    
    var url: URL? { get }
    
    var timeoutInterval: TimeInterval { get }
    
    var shouldLogRequest: Bool { get }
    
    var shouldLogResponse: Bool { get }
    
    var shouldRetryOnAuthenticateError: Bool { get }
    
    func builder() -> URLRequest
    
    func string(from authenticate: Autenticate) -> String?
}
