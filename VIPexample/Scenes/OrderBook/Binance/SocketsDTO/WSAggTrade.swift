//
//  WSAggTrade.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 09.10.2021.
//

import Foundation

struct WSAggTrade: Codable {
    let aggTradeE: String
    let e: Int
    let s: String
    let u: Int
    let aggTradeU: Int
    let b: [[String]]
    let a: [[String]]

    enum CodingKeys: String, CodingKey {
        case aggTradeE = "e"
        case e = "E"
        case s = "s"
        case u = "U"
        case aggTradeU = "u"
        case b = "b"
        case a = "a"
    }
}
