//
//  WSBinanceQuery.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 09.10.2021.
//

import Foundation

struct WSBinanceQuery: Codable {
    var method: String
    var params: [String]
    var id: Int
    
    init(method: String, params: [String], id: Int) {
        self.method = method
        self.params = params
        self.id = id
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(method, forKey: .method)
        try container.encode(params, forKey: .params)
        try container.encode(id, forKey: .id)
    }
}
