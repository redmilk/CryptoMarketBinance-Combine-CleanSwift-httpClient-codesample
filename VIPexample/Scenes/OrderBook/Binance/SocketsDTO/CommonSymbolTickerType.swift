//
//  CommonSymbolTickerType.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 09.10.2021.
//

import Foundation

enum CommonSymbolTickerType: Decodable {
    
    case multipleSymbols(SymbolTickerDTO)
    case singleSymbol(SymbolTickerNestedDTO)
    
    init(from decoder: Decoder) throws {
        if let multiple = try? SymbolTickerDTO(from: decoder) {
            self = .multipleSymbols(multiple)
            return
        }
        if let single = try? SymbolTickerNestedDTO(from: decoder) {
            self = .singleSymbol(single)
            return
        }
        throw RequestError.parsing("SymbolTickerType parsing failure", nil)
    }
    
}
