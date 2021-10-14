//
//  MarketBoardMainCell.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 12.10.2021.
//

import UIKit
import Combine
#warning("Refactor to collection of controls")
fileprivate let highlightedFontSize: CGFloat = 11
fileprivate let defaultFontSize: CGFloat = 9

final class MarketBoardMainCell: UICollectionViewCell, ModelConfigurable {
    @IBOutlet private weak var priceChangePercentLabel: UILabel!
    @IBOutlet private weak var symbolLabel: UILabel!
    @IBOutlet private weak var lastPrice: UILabel!
    @IBOutlet private weak var highPriceLabel: UILabel!
    @IBOutlet private weak var lowPriceLabel: UILabel!
    @IBOutlet private weak var totalTradedBase: UILabel!
    @IBOutlet private weak var totalTradedQuote: UILabel!
    @IBOutlet private weak var totalNumberOfTrades: UILabel!
    @IBOutlet private weak var bestBidQuantity: UILabel!
    @IBOutlet private weak var bestAskQuantity: UILabel!
    @IBOutlet private weak var bestBidPrice: UILabel!
    @IBOutlet private weak var bestAskPrice: UILabel!
    @IBOutlet private weak var statisticsCloseTime: UILabel!
    @IBOutlet private weak var lastQuantityLabel: UILabel!
    @IBOutlet private weak var averagePriceLabel: UILabel!
    
    func configure(withModel model: SymbolTickerElement) {
        priceChangePercentLabel.text = (model.priceChangePercent > 0 ? "+" : "") + (String(format: "%.2f", model.priceChangePercent) + "%")
        symbolLabel.text = model.symbol.uppercased().replacingOccurrences(of: "USDT", with: "")
        lastPrice.text = model.lastPrice
        highPriceLabel.text = model.highPrice.description
        lowPriceLabel.text = model.lowPrice.description
        totalTradedBase.text = model.totalTradedBaseAssetVolume
        
        bestBidQuantity.text = model.bestBidQuantity
        bestAskQuantity.text = model.bestAskQuantity
        bestBidPrice.text = model.bestBidPrice.description
        bestAskPrice.text = model.bestAskPrice.description
        totalTradedQuote.text = model.totalTradedQuoteAssetVolume
        totalNumberOfTrades.text = model.totalNumberOfTrades.description
        statisticsCloseTime.text = model.statisticsCloseTime
        lastQuantityLabel.text = model.lastQuantity
        averagePriceLabel.text = model.weightedAveragePrice.description
        
        setDefaultHighlight()
        highlighSortingField(highlightedFontSize, model: model)
    }
    
    private func highlighSortingField(_ highlightedFontSize: CGFloat, model: SymbolTickerElement) {
        guard let highlightedField = model.highlightedField else { return }
        switch highlightedField {
        case .averagePrice: averagePriceLabel.font = .systemFont(ofSize: highlightedFontSize, weight: .black)
        case .bestAskPrice: bestAskPrice.font = .systemFont(ofSize: highlightedFontSize, weight: .black)
        case .bestAskQuantity: bestAskQuantity.font = .systemFont(ofSize: highlightedFontSize, weight: .black)
        case .bestBidPrice: bestBidPrice.font = .systemFont(ofSize: highlightedFontSize, weight: .black)
        case .bestBidQuantity: bestBidQuantity.font = .systemFont(ofSize: highlightedFontSize, weight: .black)
        case .highPrice: highPriceLabel.font = .systemFont(ofSize: highlightedFontSize, weight: .black)
        case .lastPrice: lastPrice.font =  .systemFont(ofSize: highlightedFontSize, weight: .black)
        case .lastQuantity: lastQuantityLabel.font  = .systemFont(ofSize: highlightedFontSize, weight: .black)
        case .lowPrice: lowPriceLabel.font = .systemFont(ofSize: highlightedFontSize, weight: .black)
        case .priceChangePercent: priceChangePercentLabel.font = .systemFont(ofSize: highlightedFontSize, weight: .black)
        case .statisticsCloseTime: statisticsCloseTime.font = .systemFont(ofSize: highlightedFontSize, weight: .black)
        case .symbol: symbolLabel.font = .systemFont(ofSize: highlightedFontSize, weight: .black)
        case .totalNumberOfTrades: totalNumberOfTrades.font = .systemFont(ofSize: highlightedFontSize, weight: .black)
        case .totalTradedBase: totalTradedBase.font = .systemFont(ofSize: highlightedFontSize, weight: .black)
        case .totalTradedQuote: totalTradedQuote.font = .systemFont(ofSize: highlightedFontSize, weight: .black)
        }
    }
    
    private func setDefaultHighlight() {
        averagePriceLabel.font = .systemFont(ofSize: defaultFontSize, weight: .regular)
        bestAskPrice.font = .systemFont(ofSize: defaultFontSize, weight: .regular)
        bestAskQuantity.font = .systemFont(ofSize: defaultFontSize, weight: .regular)
        bestBidPrice.font = .systemFont(ofSize: defaultFontSize, weight: .regular)
        bestBidQuantity.font = .systemFont(ofSize: defaultFontSize, weight: .regular)
        highPriceLabel.font = .systemFont(ofSize: defaultFontSize, weight: .regular)
        lastQuantityLabel.font  = .systemFont(ofSize: defaultFontSize, weight: .regular)
        lowPriceLabel.font = .systemFont(ofSize: defaultFontSize, weight: .regular)
        priceChangePercentLabel.font = .systemFont(ofSize: defaultFontSize, weight: .regular)
        statisticsCloseTime.font = .systemFont(ofSize: defaultFontSize, weight: .regular)
        symbolLabel.font = .systemFont(ofSize: highlightedFontSize, weight: .regular)
        lastPrice.font =  .systemFont(ofSize: highlightedFontSize, weight: .regular)
        totalNumberOfTrades.font = .systemFont(ofSize: defaultFontSize, weight: .regular)
        totalTradedBase.font = .systemFont(ofSize: defaultFontSize, weight: .regular)
        totalTradedQuote.font = .systemFont(ofSize: defaultFontSize, weight: .regular)
    }
}
