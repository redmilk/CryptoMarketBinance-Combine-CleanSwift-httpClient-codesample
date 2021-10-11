//
//  BinanceAPI.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 28.07.2021.
//

import Foundation
import Combine

fileprivate let baseUrls = ["https://api.binance.com", "https://api1.binance.com", "https://api2.binance.com", "https://api3.binance.com"]

/// HTTP request endpoints
fileprivate enum Endpoints {
    static let exchangeInfo = "/api/v3/exchangeInfo"
    static let ping = "/api/v3/ping"
    static let priceTicker = "/api/v3/ticker/price"
    static let bookTicker = "/api/v3/ticker/bookTicker"
    static let orderBook = "/api/v3/depth"
    static let recentTrades = "/api/v3/trades"
    static let aggregatedTrades = "/api/v3/aggTrades"
    static let candlesticks = "/api/v3/klines"
    static let averagePrice = "/api/v3/avgPrice"
    static let priceChange24h = "/api/v3/ticker/24hr"
    static var baseUrl: URL { URL(string: baseUrls.first!)! }
}

protocol BinanceRequestApiType {
    init(httpClient: HTTPClientType)
    func checkPing() -> AnyPublisher<Ping, Error>
    func loadOrderBook(symbol: String, limit: Int) -> AnyPublisher<OrderBook, Error>
    func loadRecentTrades(symbol: String, limit: Int) -> AnyPublisher<[RecentTrade], Error>
    func loadAggregatedTrades(symbol: String, fromId: Int64?, startTime: Int64?, endTime: Int64?, limit: Int?) -> AnyPublisher<[RecentTrade], Error>
    func loadCandlesticks(symbol: String, interval: String, startTime: Int64?, endTime: Int64?, limit: Int?) -> AnyPublisher<[[Candlestick]], Error>
    func loadAveragePrice(symbol: String) -> AnyPublisher<AveragePrice, Error>
    func loadPriceChangeBy24Hours(symbol: String) -> AnyPublisher<PriceChange24h, Error>
    func loadPrice(symbol: String?) -> AnyPublisher<ItemOrArray<Price>, Error>
    func loadOrderBookTicker(symbol: String?) -> AnyPublisher<ItemOrArray<OrderBookTicker>, Error>
}

struct BinanceApi: BinanceRequestApiType {
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
    
    func loadOrderBook(symbol: String, limit: Int
    ) -> AnyPublisher<OrderBook, Error> {
        let headers = RequestHeaderAdapter()
        let params = RequestParametersAdapter(query: [Param("symbol", symbol), Param("limit", limit)])
        var requestBuilder = RequestBuilder(
            baseUrl: Endpoints.baseUrl,
            pathComponent: Endpoints.orderBook,
            adapters: [headers, params],
            method: .get
        )
        return httpClient.request(with: requestBuilder.request)
    }
    
    /// limit: Default 500; max 1000.
    func loadRecentTrades(symbol: String, limit: Int
    ) -> AnyPublisher<[RecentTrade], Error> {
        let headers = RequestHeaderAdapter()
        let params = RequestParametersAdapter(query: [Param("symbol", symbol), Param("limit", limit)])
        var requestBuilder = RequestBuilder(
            baseUrl: Endpoints.baseUrl,
            pathComponent: Endpoints.recentTrades,
            adapters: [headers, params],
            method: .get
        )
        return httpClient.request(with: requestBuilder.request)
    }
    
    /// limit: Default 500; max 1000.
    func loadAggregatedTrades(symbol: String,
                              fromId: Int64?,
                              startTime: Int64?,
                              endTime: Int64?,
                              limit: Int?
    ) -> AnyPublisher<[RecentTrade], Error> {
        let headers = RequestHeaderAdapter()
        let params = RequestParametersAdapter(
            query: [Param("symbol", symbol),
                    Param("fromId", fromId),
                    Param("startTime", startTime),
                    Param("endTime", endTime),
                    Param("limit", limit)]
        )
        var requestBuilder = RequestBuilder(
            baseUrl: Endpoints.baseUrl,
            pathComponent: Endpoints.aggregatedTrades,
            adapters: [headers, params],
            method: .get
        )
        return httpClient.request(with: requestBuilder.request)
    }
    
    /// Interval: 1m 3m 5m 15m 30m 1h 2h 4h 6h 8h 12h 1d 3d 1w 1M
    func loadCandlesticks(symbol: String,
                          interval: String,
                          startTime: Int64?,
                          endTime: Int64?,
                          limit: Int?
    ) -> AnyPublisher<[[Candlestick]], Error> {
        let headers = RequestHeaderAdapter()
        let params = RequestParametersAdapter(
            query: [Param("symbol", symbol),
                    Param("interval", interval),
                    Param("startTime", startTime),
                    Param("endTime", endTime),
                    Param("limit", limit)]
        )
        var requestBuilder = RequestBuilder(
            baseUrl: Endpoints.baseUrl,
            pathComponent: Endpoints.candlesticks,
            adapters: [headers, params],
            method: .get
        )
        return httpClient.request(with: requestBuilder.request)
    }
    
    func loadAveragePrice(symbol: String) -> AnyPublisher<AveragePrice, Error> {
        let headers = RequestHeaderAdapter()
        let params = RequestParametersAdapter(query: [Param("symbol", symbol)])
        var requestBuilder = RequestBuilder(
            baseUrl: Endpoints.baseUrl,
            pathComponent: Endpoints.averagePrice,
            adapters: [headers, params],
            method: .get
        )
        return httpClient.request(with: requestBuilder.request)
    }
    
    func loadPriceChangeBy24Hours(symbol: String) -> AnyPublisher<PriceChange24h, Error> {
        let headers = RequestHeaderAdapter()
        let params = RequestParametersAdapter(query: [Param("symbol", symbol)])
        var requestBuilder = RequestBuilder(
            baseUrl: Endpoints.baseUrl,
            pathComponent: Endpoints.priceChange24h,
            adapters: [headers, params],
            method: .get
        )
        return httpClient.request(with: requestBuilder.request)
    }
    
    /// if symbol is nil all symbols will return
    func loadPrice(symbol: String?) -> AnyPublisher<ItemOrArray<Price>, Error> {
        let headers = RequestHeaderAdapter()
        let params = RequestParametersAdapter(query: [Param("symbol", symbol)])
        var requestBuilder = RequestBuilder(
            baseUrl: Endpoints.baseUrl,
            pathComponent: Endpoints.priceTicker,
            adapters: [headers, params],
            method: .get
        )
        return httpClient.request(with: requestBuilder.request)
    }
    
    /// if symbol is nil all symbols will return
    /// Best price/qty on the order book for a symbol or symbols.
    func loadOrderBookTicker(symbol: String?) -> AnyPublisher<ItemOrArray<OrderBookTicker>, Error> {
        let headers = RequestHeaderAdapter()
        let params = RequestParametersAdapter(query: [Param("symbol", symbol)])
        var requestBuilder = RequestBuilder(
            baseUrl: Endpoints.baseUrl,
            pathComponent: Endpoints.bookTicker,
            adapters: [headers, params],
            method: .get
        )
        return httpClient.request(with: requestBuilder.request)
    }
}
