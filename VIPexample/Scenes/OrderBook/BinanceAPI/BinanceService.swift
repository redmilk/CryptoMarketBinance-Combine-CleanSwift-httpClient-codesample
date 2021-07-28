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
    
    func loadOrderBook(symbol: String, limit: Int) -> AnyPublisher<Ping, Error> {
        binanceApi.loadOrderBook(symbol: symbol, limit: limit)
    }
}
