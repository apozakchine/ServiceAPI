//
//  Connector.swift
//
//
//  Created by Alexander Pozakshin on 26.12.2023.
//

import Foundation

@available(iOS 15.0, *)
public class Connector {
    nonisolated(unsafe) public static var baseURLString: String?
    
    nonisolated(unsafe) public static let shared: Connector = Connector()
    
    public var session = URLSession.shared
    
    public var customErrorHandler: CustomErrorHandler = CustomErrorHandlerDefault(classes: [])
    
    public var logger: URLLogger?
    
    private let cookieManager = CookieManager.shared
    
    private let networkQueue: DispatchQueue = .init(label: "ru.serviceapikit.network.queue",
                                                    qos: .utility,
                                                    attributes: .concurrent)
    
    static func setBaseURLString(_ value: String) {
        Connector.baseURLString = value
    }
    
    func load<T: Decodable & DecoderProvider>(shouldLogRequest: Bool,
                                              shouldLogResponse: Bool,
                                              resourse: Resource<T>) async throws(ServiceAPI.Error) -> Response
    {
        setCookies()
        
        if shouldLogRequest, let jsonPretty = resourse.request.httpBody?.json()?.prettyPrinted() {
            logger?.log(type: .information, url: resourse.request.url, string: jsonPretty)
        }
        
        do {
            let (data, response) = try await session.data(for: resourse.request)
            return try await sink(response: response, ofType: T.self, data: data, logging: shouldLogResponse)
        } catch {
            if let urlError = error as? URLError {
                switch urlError.code {
                case .networkConnectionLost, .notConnectedToInternet:
                    return .fail(.status(.gatewayTimeout, Data()))
                default:
                    return .fail(.system(error))
                }
            }
            return .fail(.system(error))
        }
        
    }
    
}

@available(iOS 15.0, *)
private extension Connector {
    
    func setCookies() {
        guard let cookies = cookieManager.get else { return }
        guard let baseURLString = Connector.baseURLString else { return }
        let url = URL(string: baseURLString)
        session.configuration.httpCookieStorage?.setCookies(cookies, for: url, mainDocumentURL: url)
    }

    func sink<T: Decodable & DecoderProvider>(response: URLResponse?,
                                              ofType: T.Type,
                                              data: Data,
                                              logging: Bool) async throws(ServiceAPI.Error) -> Response
    {
        guard let response = response as? HTTPURLResponse else {
            throw .status(.gone, Data())
        }
        
        if logging, let jsonPretty = data.json()?.prettyPrinted() {
            logger?.log(type: .information, url: response.url, string: jsonPretty)
        }
        
        let status = HTTP.Status(rawValue: response.statusCode, kind: .unknown)
        
        guard status.isKnownStatus else {
            if let string = data.json()?.prettyPrinted(), !logging {
                logger?.log(type: .error, url: response.url, string: string)
            }
            throw .status(.undefined, data)
        }
        
        guard status != .unauthorized else {
            throw .status(.unauthorized, data)
        }
        
        if status.isSuccess == false {
            if let string = data.json()?.prettyPrinted(), !logging {
                logger?.log(type: .error, url: response.url, string: string)
            }
            if let error = customErrorHandler.handle(data: data) {
                throw .custom(error)
            } else {
                throw .status(status, data)
            }
        } else {
            cookieManager.save(response: response)
            return .success(data)
        }
    }

}
