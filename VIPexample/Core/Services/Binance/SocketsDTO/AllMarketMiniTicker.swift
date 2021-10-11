//
//  WSAllMarketTicker.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 09.10.2021.
//

import Foundation

// MARK: - WSAllMarketTicker
struct AllMarketMiniTicker: Codable {
    let stream: String
    let data: [AllMarketMiniTickerElement]
}

// MARK: - Datum
struct AllMarketMiniTickerElement: Codable {
    let eventTime: Int
    let eventType: String
    let symbol: String
    let highest: String
    let lowest: String
    let volume: String
    let quantity: String
    let open: String
    private let close: String
    var closePrice: String {  /// Refactor to custom init
        return close.withoutTrailingZeros//.removeZerosFromEnd(maxZerosCount: 4)
    }

    enum CodingKeys: String, CodingKey {
        case eventType = "e"
        case eventTime = "E"
        case symbol = "s"
        case close = "c"
        case open = "o"
        case highest = "h"
        case lowest = "l"
        case volume = "v"
        case quantity = "q"
    }
}
