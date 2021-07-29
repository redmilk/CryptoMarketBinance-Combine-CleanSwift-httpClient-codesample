//
//  Price.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 29.07.2021.
//

import Foundation

struct Price: Codable {
    let price: String
    let symbol: String
}

enum PriceResponse: Codable {
    case single(Price)
    case multiple([Price])
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Price.self) {
            self = .single(x)
            return
        }
        if let x = try? container.decode([Price].self) {
            self = .multiple(x)
            return
        }
        throw DecodingError.typeMismatch(Price.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Price"))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .single(let x):
            try container.encode(x)
        case .multiple(let x):
            try container.encode(x)
        }
    }
}
