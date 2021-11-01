//
//  BinanceService.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 29.07.2021.
//

import Foundation
import Combine

enum BinanceServiceError: Error {
    case emptyStreamNames(description: String)
    case websocketClient(error: Error)
}

protocol BinanceServiceWebSocketType {
    /// web socket api
    func configure(withSingleOrMultipleStreams streams: [String])
    func connect()
    func reconnect()
    func disconnect()
    func subscribeSocketResponse() -> AnyPublisher<BinanceSocketApi.SocketResponse, Never>
    func updateStreams(updateType: BinanceSocketApi.StreamUpdateMethod, forStreams streams: [String])
    func buildMarketTopBySections(allMarket: [SymbolTickerElement], prefix: Int
    ) -> [MarketBoardSectionModel]
}

protocol BinanceServiceRequestType {
    /// http request api
    func checkPing(startTime: Double) -> AnyPublisher<Double, Error>
    func loadPrice(symbol: String?) -> AnyPublisher<ItemOrArray<Price>, Error>
    func loadOrderBook(symbol: String, limit: Int) -> AnyPublisher<OrderBook, Error>
    func loadRecentTrades(symbol: String, limit: Int) -> AnyPublisher<[RecentTrade], Error>
    func loadAggregatedTrades(symbol: String, fromId: Int64?, startTime: Int64?, endTime: Int64?, limit: Int?
    ) -> AnyPublisher<[RecentTrade], Error>
    func loadCandlesticks(symbol: String, interval: String, startTime: Int64?, endTime: Int64?, limit: Int?
    ) -> AnyPublisher<[[Candlestick]], Error>
    func loadAveragePrice(symbol: String) -> AnyPublisher<AveragePrice, Error>
    func loadPriceChangeBy24Hours(symbol: String) -> AnyPublisher<PriceChange24h, Error>
    func loadOrderBookTicker(symbol: String?) -> AnyPublisher<ItemOrArray<OrderBookTicker>, Error>
}

final class BinanceService {
    private let binanceRequestApi: BinanceRequestApiType
    private let binanceSocketApi: BinanceSocketApiType
    private let filterSorter = BinanceFilterSorter()
    private var bag = Set<AnyCancellable>()

    init(binanceRequestApi: BinanceRequestApiType,
         binanceSocketApi: BinanceSocketApiType
    ) {
        self.binanceRequestApi = binanceRequestApi
        self.binanceSocketApi = binanceSocketApi
    }
    deinit {
        Logger.log(String(describing: self), type: .deinited)
    }
}

// MARK: - WebSocket API methods

extension BinanceService: BinanceServiceWebSocketType {
    
    func subscribeSocketResponse() -> AnyPublisher<BinanceSocketApi.SocketResponse, Never> {
        binanceSocketApi.streamResponse
    }
    
    func updateStreams(updateType: BinanceSocketApi.StreamUpdateMethod, forStreams streams: [String]) {
        binanceSocketApi.updateStreams(updateType: updateType, forStreams: streams)
    }
    
    func configure(withSingleOrMultipleStreams streams: [String]) {
        binanceSocketApi.configure(withSingleOrMultipleStreams: streams)
    }
    
    func connect() {
        binanceSocketApi.connect()
    }
    
    func reconnect() {
        binanceSocketApi.reconnect()
    }
    
    func disconnect() {
        binanceSocketApi.disconnect()
    }
    
    func buildMarketTopBySections(allMarket: [SymbolTickerElement], prefix: Int) -> [MarketBoardSectionModel] {
        filterSorter.buildLeaderboardSectionsBasedOnEveryField(allMarket: allMarket, prefix: prefix)
    }
}

// MARK: - HTTP Request API methods

extension BinanceService: BinanceServiceRequestType {
 
    func checkPing(startTime: Double) -> AnyPublisher<Double, Error> {
        binanceRequestApi.checkPing()
            .map { _ in startTime - Date().timeIntervalSince1970 }
            .eraseToAnyPublisher()
    }
    
    func loadPrice(symbol: String?) -> AnyPublisher<ItemOrArray<Price>, Error> {
        binanceRequestApi.loadPrice(symbol: symbol)
    }
    
    func loadOrderBook(symbol: String, limit: Int) -> AnyPublisher<OrderBook, Error> {
        binanceRequestApi.loadOrderBook(symbol: symbol, limit: limit)
    }
    
    func loadRecentTrades(symbol: String, limit: Int) -> AnyPublisher<[RecentTrade], Error> {
        binanceRequestApi.loadRecentTrades(symbol: symbol, limit: limit)
    }
    
    func loadAggregatedTrades(symbol: String, fromId: Int64? = nil, startTime: Int64? = nil, endTime: Int64? = nil, limit: Int? = nil
    ) -> AnyPublisher<[RecentTrade], Error> {
        binanceRequestApi.loadAggregatedTrades(symbol: symbol, fromId: fromId, startTime: startTime, endTime: endTime, limit: limit)
    }
    
    func loadCandlesticks(symbol: String, interval: String, startTime: Int64? = nil, endTime: Int64? = nil, limit: Int? = nil
    ) -> AnyPublisher<[[Candlestick]], Error> {
        binanceRequestApi.loadCandlesticks(symbol: symbol, interval: interval, startTime: startTime, endTime: endTime, limit: limit)
    }
    
    func loadAveragePrice(symbol: String) -> AnyPublisher<AveragePrice, Error> {
        binanceRequestApi.loadAveragePrice(symbol: symbol)
    }
    
    func loadPriceChangeBy24Hours(symbol: String) -> AnyPublisher<PriceChange24h, Error> {
        binanceRequestApi.loadPriceChangeBy24Hours(symbol: symbol)
    }
    
    func loadOrderBookTicker(symbol: String?) -> AnyPublisher<ItemOrArray<OrderBookTicker>, Error> {
        binanceRequestApi.loadOrderBookTicker(symbol: symbol)
    }
}
