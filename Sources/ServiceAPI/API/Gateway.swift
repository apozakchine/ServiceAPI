//
//  Gateway.swift
//
//
//  Created by Alexander Pozakshin on 27.12.2023.
//

import Foundation

@available(iOS 15.0, *)
public class Gateway<T: Decodable & DecoderProvider> {
    
    private let connector = Connector.shared
    
    public init() {}
    
    public func methadata(_ source: Endpoint) async throws(ServiceAPI.Error) -> NetworkResult<ServiceAPI.Error, T> {
        let resource = Resource<T>(request: source.builder(), as: .metha)
        do {
            let result = try await connector.load(shouldLogRequest: source.shouldLogRequest,
                                                  shouldLogResponse: source.shouldLogResponse,
                                                  resourse: resource)
            switch result {
            case let .success(data):
                do {
                    let response = try resource.handlers.metha(data)
                    return .success(response)
                } catch let error {
                    if let error = error as? DecodingError {
                        return .fail(.encode(error))
                    } else {
                        return .fail(.system(error))
                    }
                }
            case let .fail(error):
                return .fail(error)
            }
        } catch {
            return .fail(.system(error))
        }
    }

    public func array(_ source: Endpoint) async throws(ServiceAPI.Error) -> NetworkResult<ServiceAPI.Error, [T]> {
        let resource = Resource<T>(request: source.builder(), as: .metha)
        do {
            let result = try await connector.load(shouldLogRequest: source.shouldLogRequest,
                                                  shouldLogResponse: source.shouldLogResponse,
                                                  resourse: resource)
            switch result {
            case let .success(data):
                do {
                    let response = try resource.handlers.array(data)
                    return .success(response)
                } catch let error {
                    if let error = error as? DecodingError {
                        return .fail(.encode(error))
                    } else {
                        return .fail(.system(error))
                    }
                }
            case let .fail(error):
                return .fail(error)
            }
        } catch {
            return .fail(.system(error))
        }
    }
    
    public func raw(_ source: Endpoint) async throws(ServiceAPI.Error) -> NetworkResult<ServiceAPI.Error, Data> {
        let resource = Resource<T>(request: source.builder(), as: .metha)
        do {
            let result = try await connector.load(shouldLogRequest: source.shouldLogRequest,
                                                  shouldLogResponse: source.shouldLogResponse,
                                                  resourse: resource)
            switch result {
            case let .success(data):
                let response = resource.handlers.raw(data)
                return .success(response)
            case let .fail(error):
                return .fail(error)
            }
        } catch {
            return .fail(.system(error))
        }
    }

}

@available(iOS 15.0, *)
private extension Gateway {
    func token(withKey key: String, from header: [AnyHashable : Any]) -> String? {
        var result: String? = nil
        header.keys.compactMap({ $0 as? String }).forEach({
            if $0.uppercased() == key.uppercased() {
                result = header[$0] as? String
            }
        })
        return result
    }
}
