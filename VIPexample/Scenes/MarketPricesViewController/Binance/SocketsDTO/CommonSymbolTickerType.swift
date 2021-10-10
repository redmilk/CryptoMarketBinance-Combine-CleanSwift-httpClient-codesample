//
//  CommonSymbolTickerType.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 09.10.2021.
//
import Foundation
import Combine

enum CommonSymbolTickerType: Decodable {
    
    case multipleSymbols(SymbolTickerDTO)
    case singleSymbol(SymbolTickerNestedDTO)
    case marketMiniTicker([Datum])
    
    init(from decoder: Decoder) throws {
        if let multiple = try? SymbolTickerDTO(from: decoder) {
            self = .multipleSymbols(multiple)
            return
        }
        if let single = try? SymbolTickerNestedDTO(from: decoder) {
            self = .singleSymbol(single)
            return
        }
        if let marketMini = try? [Datum](from: decoder) {
            self = .marketMiniTicker(marketMini)
            return
        }
        throw RequestError.parsing("SymbolTickerType parsing failure", nil)
    }
    
}
