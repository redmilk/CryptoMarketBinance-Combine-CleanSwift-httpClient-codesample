//
//  WSSymbolTickerMini.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 11.10.2021.
//

import Foundation

struct SymbolTickerMini: Decodable {
    let stream: String
    let data: SymbolTickerMiniElement
}

struct SymbolTickerMiniElement: Decodable {
    let eventType: String
    let eventTime: Int
    let symbol: String
    let totalTradedBaseAssetVolume: String
    let totalTradedQuoteAssetVolume: String
    let highPrice: String
    let lowPrice: String
    let openPrice: String
    private let lastPrice: String
    var lastPriceFormatted: String {  /// Refactor to custom init
        lastPrice.withoutTrailingZeros
    }

    enum CodingKeys: String, CodingKey {
        case eventType = "e"
        case eventTime = "E"
        case symbol = "s"
        case totalTradedBaseAssetVolume = "v"
        case totalTradedQuoteAssetVolume = "q"
        case openPrice = "o"
        case highPrice = "h"
        case lowPrice = "l"
        case lastPrice = "c"
    }
}
