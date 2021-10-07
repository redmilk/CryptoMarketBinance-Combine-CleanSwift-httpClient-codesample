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
    
    private func performRequest<D: Decodable>(with urlRequest: URLRequest, shouldValidateToken: Bool = true) -> AnyPublisher<D, Error> {
        authenticator.fetchValidToken(forceRefresh: false, isAuthorizationRequred: isAuthorizationRequired, shouldValidateToken: shouldValidateToken)
            .map { urlRequest.setAuthorizationHeader(withAccessToken: $0?.accessToken) }
            .flatMap({ [unowned self] urlRequest in
                urlSession.dataTaskPublisher(for: urlRequest).mapError { $0 }
                    .flatMap ({ data, response -> AnyPublisher<Data, Error> in
                        Logger.log(data)
                        #warning("parse server error data in custom codable model")
                        guard let httpResponse = response as? HTTPURLResponse else { return .fail(RequestError.nilResponse(urlRequest)) }
                        guard  200..<300 ~= httpResponse.statusCode else {
                            Logger.log(data)
                            return .fail(httpResponse.statusCode == 401 ? RequestError.invalidToken : RequestError.api(httpResponse.statusCode, urlRequest))
                        }
                        return .just(data)
                    })
                    .decode(type: D.self, decoder: JSONDecoder())
                    .tryCatch({ [unowned self] error -> AnyPublisher<D, Error> in
                        guard let requestError = error as? RequestError, requestError == .invalidToken else { throw error }
                        return authenticator.fetchValidToken(forceRefresh: true, isAuthorizationRequred: isAuthorizationRequired, shouldValidateToken: shouldValidateToken)
                            .map { urlRequest.setAuthorizationHeader(withAccessToken: $0?.accessToken) }
                            .flatMap({ [unowned self] urlRequest in performRequest(with: urlRequest, shouldValidateToken: false) })
                            .eraseToAnyPublisher()
                    })
                    .mapError { error -> Error in
                        switch error {
                        case is DecodingError: return RequestError.parsing("Parsing failure", error)
                        case is URLError: return RequestError.network("URL request error", error as! URLError)
                        case is RequestError: return error
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

