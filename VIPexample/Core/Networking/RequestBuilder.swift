//
//  RequestBuilder.swift
//  Clawee
//
//  Created by Danyl Timofeyev on 05.05.2021.
//  Copyright © 2021 Noisy Miner. All rights reserved.
//

import Foundation

// MARK: - Type for request header and parameter adapters

protocol URLRequestAdaptable {
    func adapt(_ urlRequest: inout URLRequest)
}

// MARK: - RequestBuilder

struct RequestBuilder {
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case patch = "PATCH"
        case delete = "DELETE"
        case head = "HEAD"
    }
    private let baseUrl: URL
    private let pathComponent: String
    private let adapters: [URLRequestAdaptable]
    private let method: HTTPMethod
    private let timeoutInterval: TimeInterval
    
    lazy var request: URLRequest = {
        let url = baseUrl.appendingPathComponent(pathComponent)
        var request = URLRequest(url: url)
        adapters.forEach { $0.adapt(&request) }
        request.httpMethod = method.rawValue
        request.timeoutInterval = timeoutInterval
        return request
    }()
    
    init(baseUrl: URL,
         pathComponent: String,
         adapters: [URLRequestAdaptable],
         method: HTTPMethod,
         timoutInterval: TimeInterval = 30.0
    ) {
        self.baseUrl = baseUrl
        self.pathComponent = pathComponent
        self.adapters = adapters
        self.method = method
        self.timeoutInterval = timoutInterval
    }
}
