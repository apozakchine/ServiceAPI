//
//  URLLogger.swift
//  APIKit
//
//  Created by Alexander Pozakshin on 12.06.2024.
//

import Foundation

public enum LogType {
    case information
    case warning
    case error
}

public protocol URLLogger {
    func log(type: LogType, url: URL?, string: String)
}
