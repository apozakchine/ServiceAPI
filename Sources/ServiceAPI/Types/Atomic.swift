//
//  File.swift
//  
//
//  Created by Alexander Pozakshin on 04.12.2023.
//

import Foundation

@propertyWrapper
public class Atomic<Value>: @unchecked Sendable {
    private var lock: NSRecursiveLock = NSRecursiveLock()

    private var value: Value

    public var wrappedValue: Value {
        get {
            lock.lock(); defer { lock.unlock() }
            return value
        }

        set {
            lock.lock(); defer { lock.unlock() }
            value = newValue
        }
    }

    public init(wrappedValue value: Value) {
        self.value = value
    }
}
