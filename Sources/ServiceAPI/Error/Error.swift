//
//  Error.swift
//  
//
//  Created by Alexander Pozakshin on 24.11.2023.
//

import Foundation

public enum Error: Swift.Error, LocalizedError {
    
    case message(String)
    
    case status(HTTP.Status, Data)
    
    case system(Swift.Error)
    
    case encode(DecodingError)
    
    case custom(any CustomError)
    
    /// A localized message describing what error occurred.
    public var errorDescription: String? {
        switch self {
        case let .message(string):
            return string
        case let .status(status, _):
            return "HTTP status error: \(status.rawValue)"
        case let .system(error):
            return error.localizedDescription
        case let .encode(error):
            switch error {
            case let .typeMismatch(value, context):
                var codingPathDescription: String = context
                    .codingPath
                    .compactMap({$0.stringValue})
                    .joined(separator: " -> ")
                return "\(context.debugDescription) { \(codingPathDescription) }"
                
            case let .valueNotFound(_, context):
                var codingPathDescription: String = context
                    .codingPath
                    .compactMap({$0.stringValue})
                    .joined(separator: " -> ")
                return "\(context.debugDescription) { \(codingPathDescription) }"
                
            case let .keyNotFound(key, _):
                return "Key not found: \"\(key.stringValue)\""
                
            case let .dataCorrupted(context):
                return context.debugDescription
                
            default:
                return error.localizedDescription
            }
        case let .custom(error):
            return error.localizedDescription
        }
    }

    /// A localized message describing the reason for the failure.
    public var failureReason: String? {
        return nil
    }

    /// A localized message describing how one might recover from the failure.
    public var recoverySuggestion: String? {
        return nil
    }

    /// A localized message providing "help" text if the user requests help.
    public var helpAnchor: String? {
        return nil
    }
    
    public var isAuthorizeError: Bool {
        guard case let .status(status, _) = self else {
            return false
        }
        return status == .unauthorized
    }
    
}
