//
//  ExchangeInfo.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 10.10.2021.
//

import Foundation

// MARK: - ExchangeInfo
struct ExchangeInfo: Codable {
    let timezone: String
    let symbols: [Symbol]
    let serverTime: Int
    let rateLimits: [RateLimit]
    let exchangeFilters: [JSONAny]
}

// MARK: - RateLimit
struct RateLimit: Codable {
    let intervalNum: Int
    let interval: String
    let rateLimitType: String
    let limit: Int
}

// MARK: - Symbol
struct Symbol: Codable {
    let quoteOrderQtyMarketAllowed: Bool
    let quoteAsset: QuoteAsset
    let isSpotTradingAllowed: Bool
    let quotePrecision: Int
    let symbol: String
    let baseAsset: String
    let baseAssetPrecision: Int
    let quoteAssetPrecision: Int
    let quoteCommissionPrecision: Int
    let isMarginTradingAllowed: Bool
    let ocoAllowed: Bool
    let filters: [Filter]
    let permissions: [Permission]
    let baseCommissionPrecision: Int
    let icebergAllowed: Bool
    let status: Status
    let orderTypes: [OrderType]
}

// MARK: - Filter
struct Filter: Codable {
    let minPrice: String?
    let maxPrice: String?
    let tickSize: String?
    let filterType: FilterType
    let multiplierDown: String?
    let multiplierUp: String?
    let avgPriceMins: Int?
    let stepSize: String?
    let minQty: String?
    let maxQty: String?
    let applyToMarket: Bool?
    let minNotional: String?
    let limit: Int?
    let maxNumOrders: Int?
    let maxNumAlgoOrders: Int?
    let maxPosition: String?
}

enum FilterType: String, Codable {
    case icebergParts = "ICEBERG_PARTS"
    case lotSize = "LOT_SIZE"
    case marketLotSize = "MARKET_LOT_SIZE"
    case maxNumAlgoOrders = "MAX_NUM_ALGO_ORDERS"
    case maxNumOrders = "MAX_NUM_ORDERS"
    case maxPosition = "MAX_POSITION"
    case minNotional = "MIN_NOTIONAL"
    case percentPrice = "PERCENT_PRICE"
    case priceFilter = "PRICE_FILTER"
}

enum OrderType: String, Codable {
    case limit = "LIMIT"
    case limitMaker = "LIMIT_MAKER"
    case market = "MARKET"
    case stopLossLimit = "STOP_LOSS_LIMIT"
    case takeProfitLimit = "TAKE_PROFIT_LIMIT"
}

enum Permission: String, Codable {
    case leveraged = "LEVERAGED"
    case margin = "MARGIN"
    case spot = "SPOT"
}

enum QuoteAsset: String, Codable {
    case aud = "AUD"
    case bidr = "BIDR"
    case bkrw = "BKRW"
    case bnb = "BNB"
    case brl = "BRL"
    case btc = "BTC"
    case busd = "BUSD"
    case bvnd = "BVND"
    case dai = "DAI"
    case eth = "ETH"
    case eur = "EUR"
    case gbp = "GBP"
    case gyen = "GYEN"
    case idrt = "IDRT"
    case ngn = "NGN"
    case pax = "PAX"
    case quoteAssetTRY = "TRY"
    case rub = "RUB"
    case trx = "TRX"
    case tusd = "TUSD"
    case uah = "UAH"
    case usdc = "USDC"
    case usdp = "USDP"
    case usds = "USDS"
    case usdt = "USDT"
    case vai = "VAI"
    case xrp = "XRP"
    case zar = "ZAR"
}

enum Status: String, Codable {
    case statusBREAK = "BREAK"
    case trading = "TRADING"
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
        return nil
    }

    required init?(stringValue: String) {
        key = stringValue
    }

    var intValue: Int? {
        return nil
    }

    var stringValue: String {
        return key
    }
}
