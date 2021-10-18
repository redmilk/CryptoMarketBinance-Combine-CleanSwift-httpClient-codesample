//
//  ServicesContainer.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 28.07.2021.
//

import Combine
import Foundation

/** Handling 4 cases:
 - Valid token exists, return valid token
 - Don't have any token, user need to Sign In, throw `RequestError.signInRequired`
 - Token refreshing is in progress, share the result to other requests
 - Begin token refreshing with refresh token */
final class Authenticator {
    private var authTokens: AuthTokens? = AuthTokens(
        accessToken: "access-token-asdjfhkash3",
        tokenExpirationDate: Date(),
        refreshToken: "Prefs.refreshToken")
    private var refreshPublisher: AnyPublisher<AuthTokens?, Error>?
    private let queue = DispatchQueue(label: "authenticator-token-refreshing-serial-queue")
    private var subscriptions = Set<AnyCancellable>()

    func fetchValidToken(
        forceRefresh: Bool,
        isAuthorizationRequred: Bool,
        shouldValidateToken: Bool
    ) -> AnyPublisher<AuthTokens?, Error> {
        queue.sync { [unowned self] in
            /// whether request authorization header required
            guard isAuthorizationRequred else { return .just(nil) }
            /// token validation isn't required, just return current token
            guard shouldValidateToken else { return .just(authTokens) }
            /// we are already requesting a new token
            if let publisher = refreshPublisher { return publisher }
            /// we don't have refresh token at all, the user should log in
            guard let refreshToken = authTokens?.refreshToken,
                  let accessToken = authTokens?.accessToken else { return .fail(RequestError.signInRequired) }
            /// we already have a valid token and don't want to force a refresh
            if !accessToken.isEmpty, !(authTokens?.isExpired ?? true), !forceRefresh {
                return .just(authTokens)
            }
            /// request new access token with `refreshToken`
            refreshPublisher = requestAccessToken(withRefreshToken: refreshToken)
                .map { Optional($0) }
                .handleEvents(receiveOutput: { [unowned self] newToken in
                    authTokens = newToken
                },
                receiveCompletion: { [unowned self] _ in
                    queue.sync { refreshPublisher = nil }
                })
                .eraseToAnyPublisher()
            return refreshPublisher!
        }
    }
}

// MARK: - Internal

private extension Authenticator {
    enum Keys {
        static let refreshToken = "refreshToken"
    }
    enum Endpoints {
        static let refreshToken = "/auth/refresh"
        static var baseUrl: URL { URL(string: "https://us-central1-clawee-dev.cloudfunctions.net/api")! }
    }
    /// request fresh access token with `refreshToken`
    func requestAccessToken(withRefreshToken token: String) -> AnyPublisher<AuthTokens, Error> {
        let parameters = RequestParametersAdapter(body: [Param(Keys.refreshToken, token)], isFormUrlEncoded: true)
        let headers = RequestHeaderAdapter(contentType: ContentType.urlEncoded)
        var requestBuilder = RequestBuilder(
            baseUrl: Endpoints.baseUrl,
            pathComponent: Endpoints.refreshToken,
            adapters: [headers, parameters],
            method: .put
        )
        return URLSession.shared.dataTaskPublisher(for: requestBuilder.request)
            .eraseToAnyPublisher()
            //.delayAndRetry(forInterval: 3, scheduler: DispatchQueue.main, count: 3)
            .tryMap { data, response in
                guard let _ = response as? HTTPURLResponse else { throw RequestError.nilResponse(requestBuilder.request) }
                return data
            }
            .decode(type: AuthTokens.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
