//
//  CommonSymbolTickerType.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 09.10.2021.
//

import Foundation

enum AllStreamTickerTypes: Decodable {
    case singleSymbolMini(SymbolTickerMiniElement)
    case multipleSymbolsMini(SymbolTickerMini)
    case multipleSymbols(SymbolTicker)
    case singleSymbol(SymbolTickerElement)
    case allMarketMiniTicker([AllMarketMiniTickerElement])
    
    init(from decoder: Decoder) throws {
        if let singleTickerMini = try? SymbolTickerMiniElement(from: decoder) {
            self = .singleSymbolMini(singleTickerMini)
            return
        }
        if let multipleTickerMini = try? SymbolTickerMini(from: decoder) {
            self = .multipleSymbolsMini(multipleTickerMini)
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
        if let marketMini = try? [AllMarketMiniTickerElement](from: decoder) {
            self = .allMarketMiniTicker(marketMini)
            return
        }
        throw RequestError.parsing("AllStreamTickerTypes parsing fail, json data may be currupted", nil)
    }
}
