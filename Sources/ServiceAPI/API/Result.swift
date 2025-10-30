//
//  Result.swift
//
//
//  Created by Alexander Pozakshin on 26.12.2023.
//

import Foundation

public typealias Response = NetworkResult<ServiceAPI.Error, Data>

public enum NetworkResult<E, T> {
    
    case fail(E)
    case success(T)
    
}
