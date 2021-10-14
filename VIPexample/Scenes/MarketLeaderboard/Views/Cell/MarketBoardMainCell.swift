//
//  MarketBoardMainCell.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 12.10.2021.
//

import UIKit
import Combine
#warning("Refactor to collection of controls")
fileprivate let highlightedBackgroundColor: UIColor = UIColor.blue
fileprivate let defaultBackgroundColor: UIColor = UIColor.clear

final class MarketBoardMainCell: UICollectionViewCell, ModelConfigurable {
    
    @IBOutlet private weak var cryptoSymbolLabel: UILabel!
    @IBOutlet private weak var cryptoIconImageView: UIImageView!
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
    @IBOutlet private weak var averagePriceLabel: UILabel!
    
    func configure(withModel model: SymbolTickerElement) {
        priceChangePercentLabel.text = (model.priceChangePercent > 0 ? "+" : "") + (String(format: "%.2f", model.priceChangePercent) + "%")
        symbolLabel.text = model.symbol.uppercased()
        let baseAssetName = model.symbol.uppercased().replacingOccurrences(of: "USDT", with: "")
        cryptoIconImageView.image = UIImage(named: baseAssetName)
        cryptoIconImageView.image == nil ? cryptoIconImageView.image = UIImage(named: baseAssetName.lowercased()) : ()
        cryptoSymbolLabel.isHidden = cryptoIconImageView.image != nil
        cryptoSymbolLabel.text = baseAssetName
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
        averagePriceLabel.text = model.weightedAveragePrice.description
        setDefaultHighlight()
        highlighSortingField(highlightedBackgroundColor, model: model)
        // Specialy for SHIB tiny price
        if model.symbol.uppercased().contains("SHIB") {
            highPriceLabel.text = model.avgPriceText ?? ""
            lowPriceLabel.text = model.lowPriceText ?? ""
            averagePriceLabel.text = model.avgPriceText ?? ""
        }
    }
    
    private func highlighSortingField(_ highlightedBackgroundColor: UIColor, model: SymbolTickerElement) {
        guard let highlightedField = model.highlightedField else { return }
        switch highlightedField {
        case .averagePrice: averagePriceLabel.backgroundColor = highlightedBackgroundColor
        case .bestAskPrice: bestAskPrice.backgroundColor = highlightedBackgroundColor
        case .bestAskQuantity: bestAskQuantity.backgroundColor = highlightedBackgroundColor
        case .bestBidPrice: bestBidPrice.backgroundColor = highlightedBackgroundColor
        case .bestBidQuantity: bestBidQuantity.backgroundColor = highlightedBackgroundColor
        case .highPrice: highPriceLabel.backgroundColor = highlightedBackgroundColor
        case .lastPrice: lastPrice.backgroundColor = highlightedBackgroundColor
        case .lowPrice: lowPriceLabel.backgroundColor = highlightedBackgroundColor
        case .priceChangePercent: priceChangePercentLabel.backgroundColor = highlightedBackgroundColor
        case .symbol: symbolLabel.backgroundColor = highlightedBackgroundColor
        case .totalNumberOfTrades: totalNumberOfTrades.backgroundColor = highlightedBackgroundColor
        case .totalTradedBase: totalTradedBase.backgroundColor = highlightedBackgroundColor
        case .totalTradedQuote: totalTradedQuote.backgroundColor = highlightedBackgroundColor
        }
    }
    
    private func setDefaultHighlight() {
        averagePriceLabel.backgroundColor = defaultBackgroundColor
        bestAskPrice.backgroundColor = defaultBackgroundColor
        bestAskQuantity.backgroundColor = defaultBackgroundColor
        bestBidPrice.backgroundColor = defaultBackgroundColor
        bestBidQuantity.backgroundColor = defaultBackgroundColor
        highPriceLabel.backgroundColor = defaultBackgroundColor
        lowPriceLabel.backgroundColor = defaultBackgroundColor
        priceChangePercentLabel.backgroundColor = defaultBackgroundColor
        symbolLabel.backgroundColor = defaultBackgroundColor
        lastPrice.backgroundColor = defaultBackgroundColor
        totalNumberOfTrades.backgroundColor = defaultBackgroundColor
        totalTradedBase.backgroundColor = defaultBackgroundColor
        totalTradedQuote.backgroundColor = defaultBackgroundColor
    }
}
