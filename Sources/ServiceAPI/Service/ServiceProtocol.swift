//
//  ServiceProtocol.swift
//
//
//  Created by Alexander Pozakshin on 28.12.2023.
//

import Foundation

public protocol ServiceProtocol {}

@available(iOS 15.0, *)
public extension ServiceProtocol {
    func metha<T: Decodable & DecoderProvider>(_ source: Endpoint,
                                               gateway: Gateway<T>) async throws(ServiceAPI.Error) -> T
    {
        do {
            let result = try await gateway.methadata(source)
            switch result {
            case let .success(instance):
                return instance
            case let .fail(error):
                throw error
            }
        } catch {
            throw .system(error)
        }
    }

    func array<T: Decodable & DecoderProvider>(_ source: Endpoint,
                                               gateway: Gateway<T>) async throws(ServiceAPI.Error) -> [T]
    {
        do {
            let result = try await gateway.methadata(source)
            switch result {
            case let .success(instance):
                return [instance]
            case let .fail(error):
                throw error
            }
        } catch {
            throw .system(error)
        }
    }

    func data(_ source: Endpoint, gateway: Gateway<Data>) async throws(ServiceAPI.Error) -> Data {
        do {
            let result = try await gateway.raw(source)
            switch result {
            case let .success(instance):
                return instance
            case let .fail(error):
                throw error
            }
        } catch {
            throw .system(error)
        }
    }
}
