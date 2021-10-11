//
//  BinanceResponseModelsFormatter.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 11.10.2021.
//

import Foundation

struct BinanceResponseModelsFormatter {
   
    func formatSingleSymbolMiniTickerElement(_ symbolTickerElement: SymbolTickerMiniElement) -> String {
        "\t\(symbolTickerElement.symbol) \(symbolTickerElement.lastPriceFormatted)"
    }
    
    func formatMultipleSymbolMiniTickerElement(_ symbolTickerElement: SymbolTickerMini) -> String {
        "\t\(symbolTickerElement.data.symbol) \(symbolTickerElement.data.lastPriceFormatted)"
    }
   
    func formatSingleSymbolTickerElement(_ symbolTickerElement: SymbolTickerElement) -> String {
        "\t\(symbolTickerElement.symbol) \(symbolTickerElement.lastPriceFormatted)"
    }
    
    func formatMultipleSymbolsResponse(_ symbolTicker: SymbolTicker) -> String {
        "\t\(symbolTicker.data.symbol) \(symbolTicker.data.lastPriceFormatted)"
    }
    
    func formatAllMarketMiniTickerElements(_ elements: [AllMarketMiniTickerElement]) -> String {
        elements.map { "\($0.symbol) \($0.closePrice)" }.joined(separator: "\n")
    }
}
