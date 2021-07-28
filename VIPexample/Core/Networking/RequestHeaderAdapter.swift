//
//  RequestHeaderAdapter.swift
//  Clawee
//
//  Created by Danyl Timofeyev on 05.05.2021.
//  Copyright © 2021 Noisy Miner. All rights reserved.
//

import Foundation

// MARK: - RequestHeaderAdapter models

enum ContentType {
    static let json = "application/json"
    static let jsonUtf8 = "application/json; charset=utf-8"
    static let formData = "multipart/form-data"
    static let urlEncoded = "application/x-www-form-urlencoded"
}
extension RequestHeaderAdapter {
    enum Key: String {
        case accept = "Accept"
        case authorization = "Authorization"
        case contentType = "Content-Type"
        case deviceId = "X-User-DeviceId"
        case appVersion = "X-App-Version"
        case appPlatform = "X-Device-Platform"
        case deviceModel = "X-Device-Model"
        case platformVerion = "X-Device-Platform-Version"
    }
}
struct Header {
    let key: RequestHeaderAdapter.Key
    let value: String?
}

// MARK: - RequestHeaderAdapter

struct RequestHeaderAdapter: URLRequestAdaptable {

    private var headers: [Header]
    
    init(headers: [Header] = [],
         contentType: String = ContentType.jsonUtf8
    ) {
        self.headers = headers
    }
    
    // MARK: - URLRequestAdaptable

    func adapt(_ urlRequest: inout URLRequest) {
        headers.filter { $0.value != nil }
            .forEach { urlRequest.setValue($0.value, forHTTPHeaderField: $0.key.rawValue) }
    }
}

// MARK: - URLRequest+Extension

extension URLRequest {
    func setAuthorizationHeader(withAccessToken token: String?) -> URLRequest {
        guard let token = token else { return self }
        var authRequest = self
        authRequest.setValue("Bearer \(token)", forHTTPHeaderField: RequestHeaderAdapter.Key.authorization.rawValue)
        return authRequest
    }
}
