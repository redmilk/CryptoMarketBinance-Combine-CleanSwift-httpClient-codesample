//
//  CommonSymbolTickerType.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 09.10.2021.
//

import Foundation

enum CommonSymbolTickerType: Decodable {
    
    case multipleSymbols(WSSymbolTicker)
    case singleSymbol(WSSymbolTickerElement)
    
    init(from decoder: Decoder) throws {
        if let multiple = try? WSSymbolTicker(from: decoder) {
            self = .multipleSymbols(multiple)
            return
        }
        if let single = try? WSSymbolTickerElement(from: decoder) {
            self = .singleSymbol(single)
            return
        }
        throw RequestError.parsing("SymbolTickerType parsing failure", nil)
    }
    
}
