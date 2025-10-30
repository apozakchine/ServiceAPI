//
//  File.swift
//  APIKit
//
//  Created by Alexander Pozakshin on 09.06.2024.
//

import Foundation

public struct File: Codable, CoderProvider {
    
    public enum MIMEType: String, Codable {
        
        case png = "image/png"
        
        case jpg = "image/jpg"
        
    }
    
    
    public let mime: MIMEType
    
    public let data: Data
    
    public let named: String
    
}
