//
//  SymbolTickerDTO.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 09.10.2021.
//

import Foundation

struct SymbolTicker: Decodable {
    let stream: String
    let data: SymbolTickerElement
}

extension SymbolTickerElement: Hashable, Equatable {
    static func == (lhs: SymbolTickerElement, rhs: SymbolTickerElement) -> Bool {
        return lhs.symbol == rhs.symbol && lhs.lowPrice == rhs.lowPrice && lhs.priceChange == rhs.priceChange && lhs.lastTradeId == rhs.lastTradeId &&  lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(eventType)
        hasher.combine(eventTime)
        hasher.combine(symbol)
        hasher.combine(priceChangePercent)
        hasher.combine(priceChange)
        hasher.combine(weightedAveragePrice)
        hasher.combine(totalTradedQuoteAssetVolume)
        hasher.combine(firstTradeBefore24hrRollingWindow)
        hasher.combine(bestBidQuantity)
        hasher.combine(bestBidPrice)
        hasher.combine(bestAskQuantity)
        hasher.combine(bestAskPrice)
        hasher.combine(statisticsOpenTime)
        hasher.combine(statisticsCloseTime)
        hasher.combine(highPrice)
        hasher.combine(lowPrice)
        hasher.combine(totalTradedBaseAssetVolume)
        hasher.combine(lastQuantity)
        hasher.combine(openPrice)
        hasher.combine(firstTradeId)
        hasher.combine(lastTradeId)
        hasher.combine(lastPrice)
        hasher.combine(id)
    }
}

struct SymbolTickerElement: Decodable {
    var id: String?
    var highlightedField: HighlightedField?
    let totalNumberOfTrades: Int
    let priceChangePercent: Float
    let priceChange: Double
    let symbol: String
    let eventType: String
    let eventTime: Int
    let weightedAveragePrice: String
    let firstTradeBefore24hrRollingWindow: String
    let totalTradedQuoteAssetVolume: String
    let bestBidQuantity: String
    let bestBidPrice: String
    let bestAskQuantity: String
    let bestAskPrice: String
    let statisticsOpenTime: String
    let statisticsCloseTime: String
    let highPrice: String
    let lowPrice: String
    let totalTradedBaseAssetVolume: String
    let lastQuantity: String
    let openPrice: String
    let firstTradeId: Int
    let lastTradeId: Int
    let lastPrice: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        totalNumberOfTrades = try container.decode(Int.self, forKey: .totalNumberOfTrades)
        priceChangePercent = Float(try container.decode(String.self, forKey: .priceChangePercent))!
        priceChange = Double(try container.decode(String.self, forKey: .priceChange))!
        symbol = try container.decode(String.self, forKey: .symbol)
        eventType = try container.decode(String.self, forKey: .eventType)
        eventTime = try container.decode(Int.self, forKey: .eventTime)
        weightedAveragePrice = try container.decode(String.self, forKey: .weightedAveragePrice).withoutTrailingZeros
        firstTradeBefore24hrRollingWindow = try container.decode(String.self, forKey: .firstTradeBefore24hrRollingWindow)
        bestBidQuantity = try container.decode(String.self, forKey: .bestBidQuantity).withoutTrailingZeros
        bestBidPrice = try container.decode(String.self, forKey: .bestBidPrice).withoutTrailingZeros
        bestAskQuantity = try container.decode(String.self, forKey: .bestAskQuantity).withoutTrailingZeros
        bestAskPrice = try container.decode(String.self, forKey: .bestAskPrice).withoutTrailingZeros
        let openTime = try container.decode(Int.self, forKey: .statisticsOpenTime)
        statisticsOpenTime = DateTimeHelper.convertIntervalToDateString(openTime)
        let closeTime = try container.decode(Int.self, forKey: .statisticsCloseTime)
        statisticsCloseTime = DateTimeHelper.convertIntervalToDateString(closeTime)
        highPrice = try container.decode(String.self, forKey: .highPrice).withoutTrailingZeros
        lowPrice = try container.decode(String.self, forKey: .lowPrice).withoutTrailingZeros
        totalTradedQuoteAssetVolume = try container.decode(String.self, forKey: .totalTradedQuoteAssetVolume)
        totalTradedBaseAssetVolume = try container.decode(String.self, forKey: .totalTradedBaseAssetVolume)
        lastQuantity = try container.decode(String.self, forKey: .lastQuantity).withoutTrailingZeros
        openPrice = try container.decode(String.self, forKey: .openPrice).withoutTrailingZeros
        firstTradeId = try container.decode(Int.self, forKey: .firstTradeId)
        lastTradeId = try container.decode(Int.self, forKey: .lastTradeId)
        lastPrice = try container.decode(String.self, forKey: .lastPrice).withoutTrailingZeros
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
