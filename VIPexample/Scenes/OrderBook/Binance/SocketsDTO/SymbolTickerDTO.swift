//
//  SymbolTickerDTO.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 09.10.2021.
//

import Foundation

// MARK: - SymbolTickerDTO
struct SymbolTickerDTO: Codable {
    let eventType: String
    let eventTime: Int
    let symbol: String
    let priceChangePercent: String
    let priceChange: String
    let weightedAveragePrice: String
    let firstTradeBefore24hrRollingWindow: String
    let totalTradedQuoteAssetVolume: String
    let bestBidQuantity: String
    let bestBidPrice: String
    let bestAskQuantity: String
    let bestAskPrice: String
    let statisticsOpenTime: Int
    let statisticsCloseTime: Int
    let highPrice: String
    let lowPrice: String
    let totalTradedBaseAssetVolume: String
    let lastQuantity: String
    let openPrice: String
    let firstTradeId: Int
    let lastTradeId: Int
    let totalNumberOfTrades: Int
    private let lastPrice: String
    var lastPriceFormatted: String {
        let double = Double(lastPrice)!
        return double.removeZerosFromEnd(maxZerosCount: 4)
    }

    enum CodingKeys: String, CodingKey {
        case eventType = "e"
        case eventTime = "E"
        case symbol = "s"
        case priceChange = "p"
        case priceChangePercent = "P"
        case weightedAveragePrice = "w"
        case firstTradeBefore24hrRollingWindow = "x"
        case lastPrice = "c"
        case lastQuantity = "Q"
        case bestBidPrice = "b"
        case bestBidQuantity = "B"
        case bestAskPrice = "a"
        case bestAskQuantity = "A"
        case openPrice = "o"
        case highPrice = "h"
        case lowPrice = "l"
        case totalTradedBaseAssetVolume = "v"
        case totalTradedQuoteAssetVolume = "q"
        case statisticsOpenTime = "O"
        case statisticsCloseTime = "C"
        case firstTradeId = "F"
        case lastTradeId = "L"
        case totalNumberOfTrades = "n"
    }
}
