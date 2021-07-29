//
//  RecentTradesList.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 29.07.2021.
//

import Foundation

struct RecentTrade: Codable {
    let isBuyerMaker: Bool
    let time, id: Int
    let price: String
    let isBestMatch: Bool
    let quoteQty: String
    let qty: String
}
