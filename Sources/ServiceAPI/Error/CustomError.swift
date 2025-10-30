//
//  CustomError.swift
//  APIKit
//
//  Created by Alexander Pozakshin on 03.07.2024.
//

import Foundation

public protocol CustomError: Sendable {
    associatedtype T: Codable & CoderProvider
    
    var instance: T { get }
    var localizedDescription: String { get }
    
    init(from data: Data) throws
}

public protocol CustomErrorHandler {
    
    func handle(data: Data) -> (any CustomError)?
    
}

public class CustomErrorHandlerDefault: CustomErrorHandler {
        
    public var classes: [(any CustomError.Type)]
    
    public init(classes: [(any CustomError.Type)]) {
        self.classes = classes
    }
    
    public func handle(data: Data) -> (any CustomError)? {
        classes
            .compactMap({$0})
            .compactMap({ try? $0.init(from: data) })
            .first
    }

}
