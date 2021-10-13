//
//  MarketBoardSectionModel.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 12.10.2021.
//

import UIKit

class MarketBoardSectionModel: Hashable {
    
    let id = UUID()
    let items: [SymbolTickerElement]
    
    init(items: [SymbolTickerElement]) {
        self.items = items
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(items)
    }

    static func == (lhs: MarketBoardSectionModel, rhs: MarketBoardSectionModel) -> Bool {
        lhs.id == rhs.id
    }
}
