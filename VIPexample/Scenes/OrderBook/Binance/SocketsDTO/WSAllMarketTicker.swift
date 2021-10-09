//
//  WSAllMarketTicker.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 09.10.2021.
//

import Foundation

// MARK: - WSAllMarketTicker
struct WSAllMarketTicker: Codable {
    let stream: String
    let data: [Datum]
}

// MARK: - Datum
struct Datum: Codable {
    let eventTime: Int
    let eventType: String
    let symbol: String
    let close: String
    let open: String
    let highest: String
    let lowest: String
    let volume: String
    let quantity: String

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
