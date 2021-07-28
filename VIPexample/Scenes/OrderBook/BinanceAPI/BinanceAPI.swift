//
//  BinanceAPI.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 28.07.2021.
//

import Foundation
import Combine

fileprivate let baseUrls = ["https://api.binance.com", "https://api1.binance.com", "https://api2.binance.com", "https://api3.binance.com"]


/// Request endpoints
fileprivate enum Endpoints {
    static let ping = "/api/v3/ping"
    static let orderBook = "/api/v3/depth"
    static var baseUrl: URL { URL(string: baseUrls.first!)! }
}

protocol BinanceApiType {
    init(httpClient: HTTPClientType)
    func checkPing() -> AnyPublisher<Ping, Error>
    func loadOrderBook(symbol: String, limit: Int) -> AnyPublisher<Ping, Error>
}

struct BinanceApi: BinanceApiType {
    private let httpClient: HTTPClientType
    
    init(httpClient: HTTPClientType) {
        self.httpClient = httpClient
    }
    
    func checkPing() -> AnyPublisher<Ping, Error> {
        let headers = RequestHeaderAdapter()
        var requestBuilder = RequestBuilder(
            baseUrl: Endpoints.baseUrl,
            pathComponent: Endpoints.ping,
            adapters: [headers],
            method: .get
        )
        return httpClient.request(with: requestBuilder.request)
    }
    
    func loadOrderBook(symbol: String, limit: Int) -> AnyPublisher<Ping, Error> {
        let headers = RequestHeaderAdapter()
        let params = RequestParametersAdapter(query: [Param("symbol", symbol), Param("limit", limit)])
        var requestBuilder = RequestBuilder(
            baseUrl: Endpoints.baseUrl,
            pathComponent: Endpoints.ping,
            adapters: [headers, params],
            method: .get
        )
        return httpClient.request(with: requestBuilder.request)
    }
}
