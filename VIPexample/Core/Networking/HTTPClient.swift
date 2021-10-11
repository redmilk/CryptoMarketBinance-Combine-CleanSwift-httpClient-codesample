//
//  HTTPClient.swift
//  Clawee
//
//  Created by Danyl Timofeyev on 05.05.2021.
//  Copyright © 2021 Noisy Miner. All rights reserved.
//

import Combine
import Foundation

protocol HTTPClientType {
    func request<D: Decodable>(with urlRequest: URLRequest) -> AnyPublisher<D, Error>
}

final class HTTPClient: HTTPClientType {
    private let urlSession: URLSession
    private var isAuthorizationRequired: Bool
    private lazy var authenticator = Authenticator()
    
    init(session: URLSession = URLSession(configuration: .ephemeral),
        isAuthorizationRequired: Bool
    ) {
        self.urlSession = session
        self.isAuthorizationRequired = isAuthorizationRequired
    }
    
    func request<D: Decodable>(with urlRequest: URLRequest) -> AnyPublisher<D, Error> {
        performRequest(with: urlRequest)
    }
    
    private func performRequest<D: Decodable>(
        with urlRequest: URLRequest,
        shouldValidateToken: Bool = true
    ) -> AnyPublisher<D, Error> {
        /// if auth required try provide already saved token, otherwise make request to refresh it
        authenticator.fetchValidToken(forceRefresh: false, isAuthorizationRequred: isAuthorizationRequired, shouldValidateToken: shouldValidateToken)
            /// insert token to request header and get `URLRequest`
            .map { urlRequest.setAuthorizationHeader(withAccessToken: $0?.accessToken) }
            /// perform request block
            .flatMap({ [unowned self] urlRequest in
                urlSession.dataTaskPublisher(for: urlRequest)
                    /// map URLError to Error if occurs
                    .mapError { $0 }
                    /// get data if request succeed, check resonse model for errors
                    .flatMap ({ data, response -> AnyPublisher<Data, Error> in
                        Logger.log(data)
                        #warning("parse server error data in custom codable model")
                        /// response is empty - return custom error
                        guard let httpResponse = response as? HTTPURLResponse else { return .fail(RequestError.nilResponse(urlRequest)) }
                        /// check if status code is appropriate
                        guard 200..<300 ~= httpResponse.statusCode else {
                            Logger.log(data)
                            /// unauthorized error verification, transmit api error on other
                            return .fail(httpResponse.statusCode == 401 ? RequestError.invalidToken : RequestError.api(httpResponse.statusCode, urlRequest))
                        }
                        /// we have request data
                        return .just(data)
                    })
                    /// decode into appropriate type
                    .decode(type: D.self, decoder: JSONDecoder())
                    /// handle error from updastream, whether it's auth perform refresh token request
                    /// other requests are suspended and waiting for the new token
                    .tryCatch({ [unowned self] error -> AnyPublisher<D, Error> in
                        /// perform code below if we have to refresh or token is missing
                        guard let requestError = error as? RequestError, requestError == .invalidToken else { throw error }
                        /// force refresh token if token is missing or expired, returns fresh token
                        return authenticator.fetchValidToken(forceRefresh: true, isAuthorizationRequred: isAuthorizationRequired, shouldValidateToken: shouldValidateToken)
                            /// insert new token to request header and assign into `URLRequest`
                            .map { urlRequest.setAuthorizationHeader(withAccessToken: $0?.accessToken) }
                            /// request again with valid token
                            .flatMap({ [unowned self] urlRequest in performRequest(with: urlRequest, shouldValidateToken: false) })
                            .eraseToAnyPublisher()
                    })
                    /// define error type if occurs
                    .mapError { error -> Error in
                        switch error {
                        case is DecodingError: return RequestError.parsing("Parsing failure", error)
                        case is URLError: return RequestError.network("URL request error", error as! URLError)
                        case is RequestError: return error
                        // TODO: - look for way to refactor
                        default: return (error as NSError).code == -1001 ? RequestError.timeout(urlRequest) : RequestError.unknown(error)
                        }
                    }
            })
            .eraseToAnyPublisher()
    }
}

// MARK: - Debug
/// .handleEvents(receiveOutput: { formatPrint(urlString: $0.response.url?.absoluteString, keyWord: "auth/refresh") })
fileprivate func formatPrint(urlString: String?, keyWord: String) {
    guard let urlString = urlString else { return }
    guard urlString.contains(keyWord) else { return }
    print("🏁🏁🏁 " + urlString)
}

