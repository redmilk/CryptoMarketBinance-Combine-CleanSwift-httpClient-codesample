//
//  Candlestick.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 29.07.2021.
//

import Foundation
/**
 1499040000000,      // Open time
  "0.01634790",       // Open
  "0.80000000",       // High
  "0.01575800",       // Low
  "0.01577100",       // Close
  "148976.11427815",  // Volume
  1499644799999,      // Close time
  "2434.19055334",    // Quote asset volume
  308,                // Number of trades
  "1756.87402397",    // Taker buy base asset volume
  "28.46694368",      // Taker buy quote asset volume
  "17928899.62484339" // Ignore.
 */

enum CandlestickValue: Int {
    case openTime = 0
    case open
    case high
    case low
    case close
    case volume
    case closeTime
    case quoteAssetVolume
    case numberOfTrades
    case takerBuyBaseAssetVolume
    case takerBuyQuoteAssetVolume
    case ignore /// unneeded?
}

enum Candlestick: Codable {
    case integer(Int)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(Candlestick.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Candlestick"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}
