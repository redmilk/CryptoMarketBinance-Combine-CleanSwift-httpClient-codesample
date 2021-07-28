//
//  Error.swift
//  SmartCityProvider
//
//  Created by Edik Melnik on 5/16/17.
//  Copyright © 2017 Noisy Miner. All rights reserved.
//

import Foundation

/**
 
 HTTP Return Codes

 HTTP 4XX return codes are used for malformed requests; the issue is on the sender's side.
 HTTP 403 return code is used when the WAF Limit (Web Application Firewall) has been violated.
 HTTP 429 return code is used when breaking a request rate limit.
 HTTP 418 return code is used when an IP has been auto-banned for continuing to send requests after receiving 429 codes.
 HTTP 5XX return codes are used for internal errors; the issue is on Binance's side. It is important to NOT treat this as a failure operation; the execution status is UNKNOWN and could have been a success.
 
 
 General Information on Endpoints

 For GET endpoints, parameters must be sent as a query string.
 For POST, PUT, and DELETE endpoints, the parameters may be sent as a query string or in the request body with content type application/x-www-form-urlencoded. You may mix parameters between both the query string and request body if you wish to do so.
 Parameters may be sent in any order.
 If a parameter sent in both the query string and request body, the query string parameter will be used.
 
 
 */

enum RequestError: Error, LocalizedError, Equatable {
    case invalidToken
    case signInRequired
    case nilResponse(URLRequest)
    case api(Int, URLRequest)
    case network(String, URLError)
    case parsing(String, Error)
    case timeout(URLRequest)
    case unknown(Error)
    
    var errorDescription: String {
        switch self {
        case .invalidToken: return "Access token is invalid"
        case .signInRequired: return "Sign In required. Display authentication screen"
        case .nilResponse(let request): return "HTTPURLResponse is nil. URL \(String(describing: request.url?.absoluteString))"
        case .network(let description, let error): return description + ". " + (error.localizedDescription)
        case .timeout(let request): return "Request time out. URL \(String(describing: request.url?.absoluteString))"
        case .api(let code, let request) where code == 403: return "Resource forbidden. URL \(String(describing: request.url?.absoluteString))"
        case .api(let code, let request) where code == 404: return "Resource not found. URL \(String(describing: request.url?.absoluteString))"
        case .api(let code, let request) where 405..<500 ~= code: return "Client error. URL \(String(describing: request.url?.absoluteString))"
        case .api(let code, let request) where 500..<600 ~= code: return "Server error. URL \(String(describing: request.url?.absoluteString))"
        case .api(let code, let request): return "Api error: \(code.description). URL \(String(describing: request.url?.absoluteString))"
        case .parsing(let description, _): return description
        case .unknown(let error): return "Unknown error. Error \((error as NSError).code), \((error as NSError).localizedDescription)"
        }
    }
    
    static func == (lhs: RequestError, rhs: RequestError) -> Bool {
        lhs.errorDescription == rhs.errorDescription
    }
}
