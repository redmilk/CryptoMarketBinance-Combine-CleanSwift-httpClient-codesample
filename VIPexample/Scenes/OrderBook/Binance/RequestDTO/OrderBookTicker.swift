//
//  OrderBookTicker.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 29.07.2021.
//

import Foundation

struct OrderBookTicker: Codable {
    let bidPrice: String
    let symbol: String
    let askPrice: String
    let bidQty: String
    let askQty: String
}

//#warning("refactor to generic")
//enum OrderBookTickerResponse: Codable {
//    case single(OrderBookTicker)
//    case multiple([OrderBookTicker])
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        if let x = try? container.decode(OrderBookTicker.self) {
//            self = .single(x)
//            return
//        }
//        if let x = try? container.decode([OrderBookTicker].self) {
//            self = .multiple(x)
//            return
//        }
//        throw DecodingError.typeMismatch(OrderBookTicker.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for OrderBookTicker"))
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        switch self {
//        case .single(let x):
//            try container.encode(x)
//        case .multiple(let x):
//            try container.encode(x)
//        }
//    }
//}
