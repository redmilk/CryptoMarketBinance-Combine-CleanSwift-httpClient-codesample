//
//  MarketBoardItemModel.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 12.10.2021.
//

import Foundation

struct MarketBoardItemModel: Hashable {
    let userId: String?
    let name: String?
    let pointsSum: Int?
    let rank: Int?
    let bracketId: String?
    let countryCode: String?
    let avatar: String?
    var isChampionsBracket: Bool?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(userId)
        hasher.combine(name)
        hasher.combine(rank)
        hasher.combine(countryCode)
        hasher.combine(bracketId)
        hasher.combine(avatar)
        hasher.combine(pointsSum)
    }
    
    static func getEmptyUserRow(
        rank: Int,
        isChampionsBracket: Bool,
        userId: String = UUID().uuidString
    ) -> MarketBoardItemModel {
        MarketBoardItemModel(userId: userId, name: nil, pointsSum: nil, rank: rank, bracketId: nil, countryCode: nil, avatar: nil, isChampionsBracket: isChampionsBracket)
    }
    
    var isEmptyUserRow: Bool {
        name == nil && pointsSum == nil && countryCode == nil && avatar == nil
    }
}
