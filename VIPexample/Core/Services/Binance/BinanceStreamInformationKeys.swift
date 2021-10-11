//
//  BinanceStreamInformationKeys.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 09.10.2021.
//

import Foundation

enum BinanceStreamInformationTypes {
    case tradeStreams(symbols: [String])
    case candleSticks(symbol: String, interval: String)
    case individualSymbolMiniTicker(symbol: String)
    case individualSymbolTicker(symbol: String)
    case allMarketMiniTickerStream
    case allMarketTickerStream
    case individualSymbolBookTicker(symbol: String)
    case allBookTickerStream
    /// <symbol>@depth<levels> OR <symbol>@depth<levels>@100ms,  <levels> are 5, 10, or 20,  1000ms or 100ms
    case partialBookDepthStreams(symbol: String, depth: String, updateSpeed: String)
    /// <symbol>@depth OR <symbol>@depth@100ms, 1000ms or 100ms
    case diffDepthStream(symbol: String, depth: String, updateSpeed: String)
    
    var composedStreamNameAndSettings: [String] {
        switch self {
        case .tradeStreams(let symbols):
            return symbols.map { $0 + "@trade" }
        case .candleSticks(let symbol, let interval):
            return [symbol + "@kline_" + interval]
        case .individualSymbolMiniTicker(let symbol):
            return [symbol + "@miniTicker"]
        case .individualSymbolTicker(let symbol):
            return [symbol + "@ticker"]
        case .allMarketMiniTickerStream: return ["!miniTicker@arr"]
        case .allMarketTickerStream: return ["!ticker@arr"]
        case .individualSymbolBookTicker(let symbol): return [symbol + "@bookTicker"]
        case .allBookTickerStream: return ["!bookTicker"]
        case .partialBookDepthStreams(let symbol, let depth, let updateSpeed):
            return [symbol + "@depth" + depth + "@" + updateSpeed]
        case .diffDepthStream(let symbol, let depth, let updateSpeed):
            return [symbol + "@depth" + depth + "@" + updateSpeed]
        }
    }
}

enum Depth: String {
    case five = "5"
    case ten = "10"
    case twenty = "20"
}

enum UpdateSpeed: String {
    case ms100 = "100ms"
    case ms1000 = "1000ms"
}

/// m -> minutes; h -> hours; d -> days; w -> weeks; M -> months
enum CandleSticks: String {
    case min1 = "1m"
    case min3 = "3m"
    case min5 = "5m"
    case min15 = "15m"
    case min30 = "30m"
    case hour1 = "1h"
    case hour2 = "2h"
    case hour4 = "4h"
    case hour6 = "6h"
    case hour8 = "8h"
    case hour12 = "12h"
    case day1 = "1d"
    case day3 = "3d"
    case week1 = "1w"
    case month1 = "1M"
}

/**
 (FOR CANDLESTICKS)
 m -> minutes; h -> hours; d -> days; w -> weeks; M -> months

 1m
 3m
 5m
 15m
 30m
 1h
 2h
 4h
 6h
 8h
 12h
 1d
 3d
 1w
 1M
 
 
 How to manage a local order book correctly

 Open a stream to wss://stream.binance.com:9443/ws/bnbbtc@depth.
 Buffer the events you receive from the stream.
 Get a depth snapshot from https://api.binance.com/api/v3/depth?symbol=BNBBTC&limit=1000 .
 Drop any event where u is <= lastUpdateId in the snapshot.
 The first processed event should have U <= lastUpdateId+1 AND u >= lastUpdateId+1.
 While listening to the stream, each new event's U should be equal to the previous event's u+1.
 The data in each event is the absolute quantity for a price level.
 If the quantity is 0, remove the price level.
 Receiving an event that removes a price level that is not in your local order book can happen and is normal.
 */

