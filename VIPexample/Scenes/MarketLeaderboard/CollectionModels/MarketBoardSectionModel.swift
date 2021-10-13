//
//  MarketBoardSectionModel.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 12.10.2021.
//

import UIKit

class MarketBoardSectionModel: Hashable {
    
    let id = UUID()
    let title: String
    let rewardAmount: String
    let users: [MarketBoardItemModel]
    
    init(title: String, rewardAmount: String, isChampionsBracket: Bool, users: [MarketBoardItemModel]) {
        self.title = title
        self.rewardAmount = rewardAmount
        self.users = isChampionsBracket ? formatUsersFromChampionBracket(users) : users
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(users)
    }

//    static func < (lhs: MarketBoardSectionModel, rhs: MarketBoardSectionModel) -> Bool {
//        lhs.rewardAmount > rhs.rewardAmount
//    }
//
    static func == (lhs: MarketBoardSectionModel, rhs: MarketBoardSectionModel) -> Bool {
        lhs.id == rhs.id
    }
}

fileprivate func formatUsersFromChampionBracket(_ users: [MarketBoardItemModel]) -> [MarketBoardItemModel] {
    return users.map { (user: MarketBoardItemModel) -> MarketBoardItemModel in
        var u = user
        u.isChampionsBracket = true
        return u
    }
}
