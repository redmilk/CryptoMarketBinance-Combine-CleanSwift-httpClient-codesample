//
//  BinanceFilter.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 14.10.2021.
//

import Foundation

protocol DataModifierStrategyType {
    func applyModifier(toMarketStreamData data: inout [SymbolTickerElement])
}

#warning("Refactor code smells")

struct BinanceFilterSorter {
    
    func applyModifiersToData(
        modifiers: [DataModifierStrategyType],
        allMarket: inout [SymbolTickerElement]
    ) {
        modifiers.forEach { $0.applyModifier(toMarketStreamData: &allMarket) }
    }
    
    private func makeSectionItemsUnique(items: inout [SymbolTickerElement], sortType: HighlightedField) {
        items = items.map {
            var item = $0
            item.id = UUID().uuidString
            item.highlightedField = sortType
            return item
        }
    }
    
    func buildLeaderboardSectionsBasedOnEveryField(
        allMarket: [SymbolTickerElement],
        prefix: Int) -> [MarketBoardSectionModel] {
        
        var sections: [MarketBoardSectionModel] = []
        // usdt
        var excludeUpDownAndContainsUsdt = allMarket
        applyModifiersToData(modifiers: [UsdtAsQuoteAssetFilterAndExcludeBlvUpDown()], allMarket: &excludeUpDownAndContainsUsdt)
        
        var totalTradesAmountTopA = excludeUpDownAndContainsUsdt
        applyModifiersToData(modifiers: [TotalTradesAmountSorter(isAscending: true), RequiredAmountOfDataFetcher(prefix)], allMarket: &totalTradesAmountTopA)
        makeSectionItemsUnique(items: &totalTradesAmountTopA, sortType: .totalNumberOfTrades)
        sections.append(MarketBoardSectionModel(items: totalTradesAmountTopA, title: "Total number of trades ⤵️", highlightedField: .totalNumberOfTrades))
        
        var priceChangePercentA = excludeUpDownAndContainsUsdt
        applyModifiersToData(modifiers: [PriceChangePercentSorter(isAscending: true), RequiredAmountOfDataFetcher(prefix)], allMarket: &priceChangePercentA)
        makeSectionItemsUnique(items: &priceChangePercentA, sortType: .priceChangePercent)
        sections.append(MarketBoardSectionModel(items: priceChangePercentA, title: "Price change percent ⤵️", highlightedField: .priceChangePercent))

        var priceChangePercentD = excludeUpDownAndContainsUsdt
        applyModifiersToData(modifiers: [PriceChangePercentSorter(isAscending: false), RequiredAmountOfDataFetcher(prefix)], allMarket: &priceChangePercentD)
        makeSectionItemsUnique(items: &priceChangePercentD, sortType: .priceChangePercent)
        sections.append(MarketBoardSectionModel(items: priceChangePercentD, title: "Price change percent ⤴️", highlightedField: .priceChangePercent))
        
        var highPriceD = excludeUpDownAndContainsUsdt
        applyModifiersToData(modifiers: [HighPriceSorter(isAscending: false), RequiredAmountOfDataFetcher(prefix)], allMarket: &highPriceD)
        makeSectionItemsUnique(items: &highPriceD, sortType: .highPrice)
        sections.append(MarketBoardSectionModel(items: highPriceD, title: "High price ⤴️", highlightedField: .highPrice))
        
        var highPriceA = excludeUpDownAndContainsUsdt
        applyModifiersToData(modifiers: [HighPriceSorter(isAscending: true), RequiredAmountOfDataFetcher(prefix)], allMarket: &highPriceA)
        makeSectionItemsUnique(items: &highPriceA, sortType: .highPrice)
        sections.append(MarketBoardSectionModel(items: highPriceA, title: "High price ⤵️", highlightedField: .highPrice))

        var lowPriceD = excludeUpDownAndContainsUsdt
        applyModifiersToData(modifiers: [LowPriceSorter(isAscending: false), RequiredAmountOfDataFetcher(prefix)], allMarket: &lowPriceD)
        makeSectionItemsUnique(items: &lowPriceD, sortType: .lowPrice)
        sections.append(MarketBoardSectionModel(items: lowPriceD, title: "Low price ⤴️", highlightedField: .lowPrice))
        
        var lowPriceA = excludeUpDownAndContainsUsdt
        applyModifiersToData(modifiers: [LowPriceSorter(isAscending: true), RequiredAmountOfDataFetcher(prefix)], allMarket: &lowPriceA)
        makeSectionItemsUnique(items: &lowPriceA, sortType: .lowPrice)
        sections.append(MarketBoardSectionModel(items: lowPriceA, title: "Low price ⤵️", highlightedField: .lowPrice))
        
        var weightedAveragePriceD = excludeUpDownAndContainsUsdt
        applyModifiersToData(modifiers: [WeightedAveragePriceSorter(isAscending: false), RequiredAmountOfDataFetcher(prefix)], allMarket: &weightedAveragePriceD)
        makeSectionItemsUnique(items: &weightedAveragePriceD, sortType: .averagePrice)
        
        sections.append(MarketBoardSectionModel(items: weightedAveragePriceD, title: "Weighted average price ⤴️", highlightedField: .averagePrice))
        var weightedAveragePriceA = excludeUpDownAndContainsUsdt
        applyModifiersToData(modifiers: [WeightedAveragePriceSorter(isAscending: true), RequiredAmountOfDataFetcher(prefix)], allMarket: &weightedAveragePriceA)
        makeSectionItemsUnique(items: &weightedAveragePriceA, sortType: .averagePrice)
        sections.append(MarketBoardSectionModel(items: weightedAveragePriceA, title: "Weighted average price ⤵️", highlightedField: .averagePrice))

        // no usdt
        return sections
    }
    
    // MARK: - Data modifier strategies
    
    struct UsdtAsQuoteAssetFilterAndExcludeBlvUpDown: DataModifierStrategyType {
        func applyModifier(toMarketStreamData data: inout [SymbolTickerElement]) {
            data = data.filter { $0.symbol.lowercased().contains("usdt") && !$0.symbol.lowercased().contains("down") }
        }
    }
    
    struct TotalTradesAmountSorter: DataModifierStrategyType {
        private let isAscending: Bool
        init(isAscending: Bool) {
            self.isAscending = isAscending
        }
        func applyModifier(toMarketStreamData data: inout [SymbolTickerElement]) {
            data = data.sorted(by: { isAscending ? $0.totalNumberOfTrades > $1.totalNumberOfTrades : $0.totalNumberOfTrades < $1.totalNumberOfTrades })
        }
    }
    
    struct TotalTradesAmountFilter: DataModifierStrategyType {
        private let minTotalNumberOfTradesRequired: Int = 100_000
        func applyModifier(toMarketStreamData data: inout [SymbolTickerElement]) {
            data = data.filter { $0.totalNumberOfTrades > minTotalNumberOfTradesRequired }
        }
    }
    
    struct PriceChangePercentSorter: DataModifierStrategyType {
        private let isAscending: Bool
        init(isAscending: Bool) {
            self.isAscending = isAscending
        }
        func applyModifier(toMarketStreamData data: inout [SymbolTickerElement]) {
            data = data.sorted(by: { isAscending ? $0.priceChangePercent > $1.priceChangePercent : $0.priceChangePercent < $1.priceChangePercent })
        }
    }
    
    struct RequiredAmountOfDataFetcher: DataModifierStrategyType {
        private let requiredAmountOfData: Int
        init(_ requiredAmountOfData: Int = 100) {
            self.requiredAmountOfData = requiredAmountOfData
        }
        func applyModifier(toMarketStreamData data: inout [SymbolTickerElement]) {
            data = Array(data.prefix(requiredAmountOfData))
        }
    }
    
    struct PriceChangeSorter: DataModifierStrategyType {
        private let isAscending: Bool
        init(isAscending: Bool) {
            self.isAscending = isAscending
        }
        func applyModifier(toMarketStreamData data: inout [SymbolTickerElement]) {
            data = data.sorted(by: { isAscending ? $0.priceChange > $1.priceChange : $0.priceChange < $1.priceChange })
        }
    }
    
    struct WeightedAveragePriceSorter: DataModifierStrategyType {
        private let isAscending: Bool
        init(isAscending: Bool) {
            self.isAscending = isAscending
        }
        func applyModifier(toMarketStreamData data: inout [SymbolTickerElement]) {
            data = data.sorted(by: { isAscending ? $0.weightedAveragePrice > $1.weightedAveragePrice : $0.weightedAveragePrice < $1.weightedAveragePrice })
        }
    }
    
    struct LastQuantitySorter: DataModifierStrategyType {
        private let isAscending: Bool
        init(isAscending: Bool) {
            self.isAscending = isAscending
        }
        func applyModifier(toMarketStreamData data: inout [SymbolTickerElement]) {
            data = data.sorted(by: { isAscending ? $0.lastQuantity > $1.lastQuantity : $0.lastQuantity < $1.lastQuantity })
        }
    }
    
    struct HighPriceSorter: DataModifierStrategyType {
        private let isAscending: Bool
        init(isAscending: Bool) {
            self.isAscending = isAscending
        }
        func applyModifier(toMarketStreamData data: inout [SymbolTickerElement]) {
            data = data.sorted(by: { isAscending ? $0.highPrice > $1.highPrice : $0.highPrice < $1.highPrice })
        }
    }
    
    struct LowPriceSorter: DataModifierStrategyType {
        private let isAscending: Bool
        init(isAscending: Bool) {
            self.isAscending = isAscending
        }
        func applyModifier(toMarketStreamData data: inout [SymbolTickerElement]) {
            data = data.sorted(by: { isAscending ? $0.lowPrice > $1.lowPrice : $0.lowPrice < $1.lowPrice })
        }
    }
  
    // TODO: - Left
    
    struct TotalTradedQuoteAssetVolumeSorter: DataModifierStrategyType {
        func applyModifier(toMarketStreamData data: inout [SymbolTickerElement]) {
            data = data.sorted(by: { $0.totalTradedQuoteAssetVolume > $1.totalTradedQuoteAssetVolume })
        }
    }
    
    struct TotalTradedBaseAssetVolumeSorter: DataModifierStrategyType {
        func applyModifier(toMarketStreamData data: inout [SymbolTickerElement]) {
            data = data.sorted(by: { $0.totalTradedBaseAssetVolume > $1.totalTradedBaseAssetVolume })
        }
    }
    
    struct BestBidQuantitySorter: DataModifierStrategyType {
        func applyModifier(toMarketStreamData data: inout [SymbolTickerElement]) {
            data = data.sorted(by: { $0.bestBidQuantity > $1.bestBidQuantity })
        }
    }
    
    struct BestBidPriceSorter: DataModifierStrategyType {
        func applyModifier(toMarketStreamData data: inout [SymbolTickerElement]) {
            data = data.sorted(by: { $0.bestBidPrice > $1.bestBidPrice })
        }
    }
    
    struct BestAskQuantitySorter: DataModifierStrategyType {
        func applyModifier(toMarketStreamData data: inout [SymbolTickerElement]) {
            data = data.sorted(by: { $0.bestAskQuantity > $1.bestAskQuantity })
        }
    }
    
    struct BestAskPriceSorter: DataModifierStrategyType {
        func applyModifier(toMarketStreamData data: inout [SymbolTickerElement]) {
            data = data.sorted(by: { $0.bestAskPrice > $1.bestAskPrice })
        }
    }
    
    struct OpenPriceSorter: DataModifierStrategyType {
        func applyModifier(toMarketStreamData data: inout [SymbolTickerElement]) {
            data = data.sorted(by: { $0.openPrice > $1.openPrice })
        }
    }
    
    struct LastPriceSorter: DataModifierStrategyType {
        func applyModifier(toMarketStreamData data: inout [SymbolTickerElement]) {
            data = data.sorted(by: { $0.lastPrice > $1.lastPrice })
        }
    }
    
    struct FirstTradeBefore24hrRollingWindowSorter: DataModifierStrategyType {
        func applyModifier(toMarketStreamData data: inout [SymbolTickerElement]) {
            data = data.sorted(by: { $0.firstTradeBefore24hrRollingWindow > $1.firstTradeBefore24hrRollingWindow })
        }
    }
}
