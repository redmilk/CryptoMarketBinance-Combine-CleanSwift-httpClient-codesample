//
//  BinanceService.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 29.07.2021.
//

import Foundation
import Combine

enum BinanceServiceError: Error { }

final class BinanceService {
    private let binanceApi: BinanceApiType
    private var bag = Set<AnyCancellable>()

    init(binanceApi: BinanceApiType) {
        self.binanceApi = binanceApi
    }
    
    func checkPing(startTime: Double) -> AnyPublisher<Double, Error> {
        binanceApi.checkPing()
            .map { _ in startTime - Date().timeIntervalSince1970 }
            .eraseToAnyPublisher()
    }
    
    func loadPrice(symbol: String?) -> AnyPublisher<ItemOrArray<Price>, Error> {
        binanceApi.loadPrice(symbol: symbol)
    }
    
    func loadOrderBook(symbol: String, limit: Int) -> AnyPublisher<OrderBook, Error> {
        binanceApi.loadOrderBook(symbol: symbol, limit: limit)
    }
    
    func loadRecentTrades(symbol: String, limit: Int) -> AnyPublisher<[RecentTrade], Error> {
        binanceApi.loadRecentTrades(symbol: symbol, limit: limit)
    }
    
    func loadAggregatedTrades(symbol: String,
                              fromId: Int64? = nil,
                              startTime: Int64? = nil,
                              endTime: Int64? = nil,
                              limit: Int? = nil
    ) -> AnyPublisher<[RecentTrade], Error> {
        binanceApi.loadAggregatedTrades(symbol: symbol, fromId: fromId, startTime: startTime, endTime: endTime, limit: limit)
    }
    
    func loadCandlesticks(symbol: String,
                          interval: String,
                          startTime: Int64? = nil,
                          endTime: Int64? = nil,
                          limit: Int? = nil
    ) -> AnyPublisher<[[Candlestick]], Error> {
        binanceApi.loadCandlesticks(symbol: symbol, interval: interval, startTime: startTime, endTime: endTime, limit: limit)
    }
    
    func loadAveragePrice(symbol: String) -> AnyPublisher<AveragePrice, Error> {
        binanceApi.loadAveragePrice(symbol: symbol)
    }
    
    func loadPriceChangeBy24Hours(symbol: String) -> AnyPublisher<PriceChange24h, Error> {
        binanceApi.loadPriceChangeBy24Hours(symbol: symbol)
    }
    
    func loadOrderBookTicker(symbol: String?) -> AnyPublisher<OrderBookTickerResponse, Error> {
        binanceApi.loadOrderBookTicker(symbol: symbol)
    }
}
