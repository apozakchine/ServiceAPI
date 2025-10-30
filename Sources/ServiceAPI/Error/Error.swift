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
    
    public var localizedDescription: String? {
        switch self {
        case let .message(string):
            return string
        case let .status(status, _):
            return "\("http.status".localized()): \(status.rawValue)"
        case let .system(error):
            return error.localizedDescription
        case let .encode(error):
            switch error {
            case let .typeMismatch(_, context):
                return "\("type.mismatch".localized()): \(context.debugDescription) (\(context.codingPath)"
            case let .valueNotFound(_, context):
                return "\("value.not.found".localized()): (\(context.codingPath))"
            case let .keyNotFound(key, context):
                return "\("key.not.found".localized()): \(key.description) (\(context.debugDescription)"
            case let .dataCorrupted(context):
                return context.debugDescription
            default:
                return error.localizedDescription
            }
        case let .custom(error):
            return error.localizedDescription
        }
    }
    
    public var isAuthorizeError: Bool {
        guard case let .status(status, _) = self else {
            return false
        }
        return status == .unauthorized
    }
}
