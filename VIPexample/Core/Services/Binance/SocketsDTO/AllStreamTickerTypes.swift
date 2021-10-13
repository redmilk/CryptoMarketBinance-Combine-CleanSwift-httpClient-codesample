//
//  CommonSymbolTickerType.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 09.10.2021.
//

import Foundation

enum AllStreamTickerTypes: Decodable {
    case allMarketTicker([SymbolTickerElement])
    case allMarketMiniTicker([AllMarketMiniTickerElement])
    case singleSymbol(SymbolTickerElement)
    case singleSymbolMini(SymbolTickerMiniElement)
    case multipleSymbols(SymbolTicker)
    case multipleSymbolsMini(SymbolTickerMini)
    
    init(from decoder: Decoder) throws {
        if let allMarket = try? [SymbolTickerElement](from: decoder) {
            self = .allMarketTicker(allMarket)
            return
        }
        if let marketMini = try? [AllMarketMiniTickerElement](from: decoder) {
            self = .allMarketMiniTicker(marketMini)
            return
        }
        if let singleTickerMini = try? SymbolTickerMiniElement(from: decoder) {
            self = .singleSymbolMini(singleTickerMini)
            return
        }
        if let single = try? SymbolTickerElement(from: decoder) {
            self = .singleSymbol(single)
            return
        }
        if let multiple = try? SymbolTicker(from: decoder) {
            self = .multipleSymbols(multiple)
            return
        }
        if let multipleTickerMini = try? SymbolTickerMini(from: decoder) {
            self = .multipleSymbolsMini(multipleTickerMini)
            return
        }
        throw RequestError.parsing("AllStreamTickerTypes parsing fail, json data may be currupted", nil)
    }
}
