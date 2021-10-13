//
//  MarketBoardMainCell.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 12.10.2021.
//

import UIKit
import Combine

final class MarketBoardMainCell: UICollectionViewCell, ModelConfigurable {
    
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet weak var priceChangePercentLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var lastPrice: UILabel!
    @IBOutlet weak var firstTradePrice: UILabel!
    @IBOutlet weak var totalTradedBase: UILabel!
    @IBOutlet weak var totalTradedQuote: UILabel!
    @IBOutlet weak var totalNumberOfTrades: UILabel!
    @IBOutlet weak var priceChangeAmount: UILabel!
    @IBOutlet weak var statisticTimeLeft: UILabel!
    @IBOutlet weak var bestBidPrice: UILabel!
    @IBOutlet weak var bestBidQunatity: UILabel!
    @IBOutlet weak var bestAskPrice: UILabel!
    @IBOutlet weak var bestAskQuantity: UILabel!
    @IBOutlet weak var averagePrice: UILabel!
    
    func configure(withModel model: SymbolTickerElement) {
        priceChangePercentLabel.text = "\(model.priceChangePercent)%"
        symbolLabel.text = model.symbol.capitalized
        lastPrice.text = model.lastPriceFormatted
        firstTradePrice.text = model.firstTradeBefore24hrRollingWindow
        totalTradedBase.text = model.totalTradedBaseAssetVolume
        totalTradedQuote.text = model.totalTradedQuoteAssetVolume
        totalNumberOfTrades.text = model.totalNumberOfTrades.description
        priceChangeAmount.text = model.priceChange
        statisticTimeLeft.text = (model.statisticsCloseTime - model.statisticsOpenTime).description
        averagePrice.text = model.weightedAveragePrice
    }
}

/***
 let eventType: String
 let eventTime: Int
 let symbol: String
 let priceChangePercent: String
 let priceChange: String
 let weightedAveragePrice: String
 let firstTradeBefore24hrRollingWindow: String
 let totalTradedQuoteAssetVolume: String
 let bestBidQuantity: String
 let bestBidPrice: String
 let bestAskQuantity: String
 let bestAskPrice: String
 let statisticsOpenTime: Int
 let statisticsCloseTime: Int
 let highPrice: String
 let lowPrice: String
 let totalTradedBaseAssetVolume: String
 let lastQuantity: String
 let openPrice: String
 let firstTradeId: Int
 let lastTradeId: Int
 let totalNumberOfTrades: Int
 private let lastPrice: String
 var lastPriceFormatted: String {  /// Refactor to custom init
     lastPrice.withoutTrailingZeros
 }
 */
