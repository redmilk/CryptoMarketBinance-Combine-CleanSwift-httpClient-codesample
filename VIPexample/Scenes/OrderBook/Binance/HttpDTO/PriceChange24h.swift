//
//  PriceChange24h.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 29.07.2021.
//

import Foundation

struct PriceChange24h: Codable {
    let lastPrice, bidPrice, volume: String
    let firstId: Int
    let priceChangePercent, quoteVolume, highPrice: String
    let count: Int
    let askQty, weightedAvgPrice, lastQty: String
    let lastId, closeTime: Int
    let openPrice, symbol, askPrice, lowPrice: String
    let openTime: Int
    let bidQty, priceChange, prevClosePrice: String
}
