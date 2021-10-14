//
//  MarketBoardSectionModel.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 12.10.2021.
//

import UIKit

enum HighlightedField {
    case priceChangePercent
    case symbol
    case lastPrice
    case highPrice
    case lowPrice
    case totalTradedBase
    case totalTradedQuote
    case totalNumberOfTrades
    case bestBidQuantity
    case bestAskQuantity
    case bestBidPrice
    case bestAskPrice
    case averagePrice
}

struct MarketBoardSectionModel: Hashable {
    var id: String?
    let title: String
    let highlightedField: HighlightedField
    let items: [SymbolTickerElement]
    
    init(items: [SymbolTickerElement], title: String, highlightedField: HighlightedField) {
        self.items = items
        self.title = title
        self.highlightedField = highlightedField
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(items)
        hasher.combine(title)
        hasher.combine(id)
    }

    static func == (lhs: MarketBoardSectionModel, rhs: MarketBoardSectionModel) -> Bool {
        lhs.title == rhs.title && lhs.items == rhs.items && lhs.id == rhs.id
    }
}
