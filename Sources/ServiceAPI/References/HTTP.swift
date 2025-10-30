//
//  HTTP.swift
//  APIServiceKit: https://github.com/DaveWoodCom/XCGLogger
//
//  Created by Dave Wood on 2016-08-30.
//  Copyright © 2016 Dave Wood, Cerebral Gardens.
//  Some rights reserved: https://github.com/DaveWoodCom/XCGLogger/blob/main/LICENSE.txt
//

public class HTTP: @unchecked Sendable {
    
    public enum Method {
        
        case get
        case post
        case put
        case delete
        case patch
        
    }

    public struct Status: @unchecked Sendable {
        
        public enum Kind {
            case information
            case successfull
            case redirect
            case clientError
            case serverError
            case unknown
        }
        
        public static let allCases: [HTTP.Status] = [
            .continiue,
            .switchingProtocol,
            .processing,
            .earlyHints,
            .successPut,
            .success,
            .accepted,
            .nonAuthoritativeInformation,
            .noContent,
            .resetContent,
            .partialContent,
            .multiStatus,
            .alreadyReported,
            .imUsed,
            .multiplieChoices,
            .movedPermanently,
            .found,
            .seeOther,
            .notModified,
            .useProxy,
            .unused,
            .temporaryRedirect,
            .permanentRedirect,
            .badRequest,
            .unauthorized,
            .paymentRedirect,
            .forbidden,
            .notFound,
            .methodNotAllowed,
            .notAcceptable,
            .proxyAuthenticationRequired,
            .requestTimeout,
            .conflict,
            .gone,
            .lengthRequired,
            .preconditionFailed,
            .payloadTooLarge,
            .uriTooLong,
            .unsupportedMediaType,
            .rangeNotSatisfiable,
            .expectationFailed,
            .imATeapot,
            .misdirectedRequest,
            .unprocessableContent,
            .locked,
            .failedDependency,
            .tooEarly,
            .upgradeRequired,
            .preconditionRequired,
            .tooManyRequests,
            .requestHeaderFieldsTooLarge,
            .unavailableForLegalReasons,
            .internalServerError,
            .notImplemented,
            .badGateway,
            .serviceUnavailable,
            .gatewayTimeout,
            .httpVersionNotSupported,
            .variantAlsoNegotiates,
            .insufficientStorage,
            .loopDetected,
            .notExtended,
            .networkAuthenticationRequired
        ]
        
        nonisolated(unsafe) public static var continiue: Status = .init(rawValue: 100, kind: .information)
        
        nonisolated(unsafe) public static var switchingProtocol: Status = .init(rawValue: 101, kind: .information)
        
        nonisolated(unsafe) public static var processing: Status = .init(rawValue: 102, kind: .information)
        
        nonisolated(unsafe) public static var earlyHints: Status = .init(rawValue: 103, kind: .information)
        
        nonisolated(unsafe) public static var successPut: Status = .init(rawValue: 200, kind: .successfull)
        
        nonisolated(unsafe) public static var success: Status = .init(rawValue: 201, kind: .successfull)
        
        nonisolated(unsafe) public static var accepted: Status = .init(rawValue: 202, kind: .successfull)
        
        nonisolated(unsafe) public static var nonAuthoritativeInformation: Status = .init(rawValue: 203, kind: .successfull)
        
        nonisolated(unsafe) public static var noContent: Status = .init(rawValue: 204, kind: .successfull)

        nonisolated(unsafe) public static var resetContent: Status = .init(rawValue: 205, kind: .successfull)
        
        nonisolated(unsafe) public static var partialContent: Status = .init(rawValue: 206, kind: .successfull)

        nonisolated(unsafe) public static var multiStatus: Status = .init(rawValue: 207, kind: .successfull)
        
        nonisolated(unsafe) public static var alreadyReported: Status = .init(rawValue: 208, kind: .successfull)
        
        nonisolated(unsafe) public static var imUsed: Status = .init(rawValue: 226, kind: .successfull)

        nonisolated(unsafe) public static var multiplieChoices: Status = .init(rawValue: 300, kind: .redirect)
        
        nonisolated(unsafe) public static var movedPermanently: Status = .init(rawValue: 301, kind: .redirect)
        
        nonisolated(unsafe) public static var found: Status = .init(rawValue: 302, kind: .redirect)
        
        nonisolated(unsafe) public static var seeOther: Status = .init(rawValue: 303, kind: .redirect)
        
        nonisolated(unsafe) public static var notModified: Status = .init(rawValue: 304, kind: .redirect)
        
        nonisolated(unsafe) public static var useProxy: Status = .init(rawValue: 305, kind: .redirect)
        
        nonisolated(unsafe) public static var unused: Status = .init(rawValue: 306, kind: .redirect)
        
        nonisolated(unsafe) public static var temporaryRedirect: Status = .init(rawValue: 307, kind: .redirect)
        
        nonisolated(unsafe) public static var permanentRedirect: Status = .init(rawValue: 308, kind: .redirect)
        
        nonisolated(unsafe) public static var badRequest: Status = .init(rawValue: 400, kind: .clientError)
        
        nonisolated(unsafe) public static var unauthorized: Status = .init(rawValue: 401, kind: .clientError)
        
        nonisolated(unsafe) public static var paymentRedirect: Status = .init(rawValue: 402, kind: .clientError)
        
        nonisolated(unsafe) public static var forbidden: Status = .init(rawValue: 403, kind: .clientError)
        
        nonisolated(unsafe) public static var notFound: Status = .init(rawValue: 404, kind: .clientError)
        
        nonisolated(unsafe) public static var methodNotAllowed: Status = .init(rawValue: 405, kind: .clientError)
        
        nonisolated(unsafe) public static var notAcceptable: Status = .init(rawValue: 406, kind: .clientError)
        
        nonisolated(unsafe) public static var proxyAuthenticationRequired: Status = .init(rawValue: 407, kind: .clientError)
        
        nonisolated(unsafe) public static var requestTimeout: Status = .init(rawValue: 408, kind: .clientError)
        
        nonisolated(unsafe) public static var conflict: Status = .init(rawValue: 409, kind: .clientError)
        
        nonisolated(unsafe) public static var gone: Status = .init(rawValue: 410, kind: .clientError)
        
        nonisolated(unsafe) public static var lengthRequired: Status = .init(rawValue: 411, kind: .clientError)
        
        nonisolated(unsafe) public static var preconditionFailed: Status = .init(rawValue: 412, kind: .clientError)
        
        nonisolated(unsafe) public static var payloadTooLarge: Status = .init(rawValue: 413, kind: .clientError)
        
        nonisolated(unsafe) public static var uriTooLong: Status = .init(rawValue: 414, kind: .clientError)
        
        nonisolated(unsafe) public static var unsupportedMediaType: Status = .init(rawValue: 415, kind: .clientError)
        
        nonisolated(unsafe) public static var rangeNotSatisfiable: Status = .init(rawValue: 416, kind: .clientError)
        
        nonisolated(unsafe) public static var expectationFailed: Status = .init(rawValue: 417, kind: .clientError)
        
        nonisolated(unsafe) public static var imATeapot: Status = .init(rawValue: 418, kind: .clientError)
        
        nonisolated(unsafe) public static var misdirectedRequest: Status = .init(rawValue: 421, kind: .clientError)
        
        nonisolated(unsafe) public static var unprocessableContent: Status = .init(rawValue: 422, kind: .clientError)
        
        nonisolated(unsafe) public static var locked: Status = .init(rawValue: 423, kind: .clientError)
        
        nonisolated(unsafe) public static var failedDependency: Status = .init(rawValue: 424, kind: .clientError)
        
        nonisolated(unsafe) public static var tooEarly: Status = .init(rawValue: 425, kind: .clientError)
        
        nonisolated(unsafe) public static var upgradeRequired: Status = .init(rawValue: 426, kind: .clientError)
        
        nonisolated(unsafe) public static var preconditionRequired: Status = .init(rawValue: 428, kind: .clientError)
        
        nonisolated(unsafe) public static var tooManyRequests: Status = .init(rawValue: 429, kind: .clientError)
        
        nonisolated(unsafe) public static var requestHeaderFieldsTooLarge: Status = .init(rawValue: 431, kind: .clientError)
        
        nonisolated(unsafe) public static var unavailableForLegalReasons: Status = .init(rawValue: 432, kind: .clientError)
        
        nonisolated(unsafe) public static var internalServerError: Status = .init(rawValue: 500, kind: .serverError)
        
        nonisolated(unsafe) public static var notImplemented: Status = .init(rawValue: 501, kind: .serverError)
        
        nonisolated(unsafe) public static var badGateway: Status = .init(rawValue: 502, kind: .serverError)
        
        nonisolated(unsafe) public static var serviceUnavailable: Status = .init(rawValue: 503, kind: .serverError)
        
        nonisolated(unsafe) public static var gatewayTimeout: Status = .init(rawValue: 504, kind: .serverError)
        
        nonisolated(unsafe) public static var httpVersionNotSupported: Status = .init(rawValue: 505, kind: .serverError)
        
        nonisolated(unsafe) public static var variantAlsoNegotiates: Status = .init(rawValue: 506, kind: .serverError)
        
        nonisolated(unsafe) public static var insufficientStorage: Status = .init(rawValue: 507, kind: .serverError)
        
        nonisolated(unsafe) public static var loopDetected: Status = .init(rawValue: 508, kind: .serverError)
        
        nonisolated(unsafe) public static var notExtended: Status = .init(rawValue: 510, kind: .serverError)
        
        nonisolated(unsafe) public static var networkAuthenticationRequired: Status = .init(rawValue: 511, kind: .serverError)
        
        nonisolated(unsafe) public static var undefined: Status = .init(rawValue: 780, kind: .unknown)

        var rawValue: Int
        
        var kind: Kind
        
        public init(rawValue: Int, kind: Kind) {
            self.rawValue = rawValue
            self.kind = kind
        }
        
    }
    
    public struct Header {
    
        nonisolated(unsafe) public static var contentType: Header = .init(rawValue: "Content-Type")
        
        nonisolated(unsafe) public static var cacheControl: Header = .init(rawValue: "Cache-Control")
        
        nonisolated(unsafe) public static var authorization: Header = .init(rawValue: "Authorization")
        
        nonisolated(unsafe) public static var language: Header = .init(rawValue: "Accept-Language")

        var rawValue: String
        
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
    }
    
}

extension HTTP.Method: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .put:
            return "PUT"
        case .delete:
            return "DELETE"
        case .patch:
            return "PATCH"
        }
    }
    
}


extension HTTP.Status: Equatable, Comparable, Hashable {
    
    public var isSuccess: Bool {
        return self >= .successPut && self <= .imUsed
    }
    
    public var isKnownStatus: Bool {
        return HTTP.Status.allCases.contains(self)
    }
    
    public static func ==(lhs: HTTP.Status, rhs: HTTP.Status) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
    
    public static func < (lhs: HTTP.Status, rhs: HTTP.Status) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
    
}

extension HTTP.Header: Equatable, Comparable, Hashable {
    
    public static func ==(lhs: HTTP.Header, rhs: HTTP.Header) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
    
    public static func < (lhs: HTTP.Header, rhs: HTTP.Header) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
    
}
