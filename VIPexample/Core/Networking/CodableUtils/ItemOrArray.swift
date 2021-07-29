//
//  ItemOrArray.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 29.07.2021.
//

import Foundation

enum ItemOrArray<T: Codable>: Codable {
    case item(T)
    case array([T])
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let item = try? container.decode(T.self) {
            self = .item(item)
            return
        }
        if let array = try? container.decode([T].self) {
            self = .array(array)
            return
        }
        throw DecodingError.typeMismatch(T.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for \(T.self)"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .item(let item): try container.encode(item)
        case .array(let array): try container.encode(array)
        }
    }
}
