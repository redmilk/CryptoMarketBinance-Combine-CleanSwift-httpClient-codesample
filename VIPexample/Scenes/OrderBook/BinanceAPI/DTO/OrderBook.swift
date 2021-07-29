//
//  OrderBook.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 29.07.2021.
//

import Foundation

struct OrderBook: Codable {
    let lastUpdateId: Int
    let asks: [[String]]
    let bids: [[String]]
}
