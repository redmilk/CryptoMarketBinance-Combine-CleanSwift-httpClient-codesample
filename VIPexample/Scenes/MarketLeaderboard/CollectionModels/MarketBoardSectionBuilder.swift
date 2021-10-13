//
//  MarketBoardSectionBuilder.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 12.10.2021.
//

import Combine

struct MarketBoardSectionBuilder {
    
    func buildSectionsWithAllMarketData(
        _ allMarket: [SymbolTicker]
    ) -> [MarketBoardSectionModel] {
        //let sortedMarket = allMarket.sorted { $0.0 < $1.0 }
        var sections: [MarketBoardSectionModel] = []
//        for (key, value) in sortedBrackets {
//            let section = LeaderboardBracketSection(
//                title: key.name,
//                rewardAmount: key.rewardInCoins.description,
//                isChampionsBracket: key.rankFrom == 1,
//                users: value)
//            sections.insert(section, at: 0)
//        }
        return sections
    }
}


/**
 
 
 
 func requesTournamentLeaderboard() -> AnyPublisher<Result<MarketBoardModel, Error>, Never> {
     tournamentApi.requestTournamentStatus()
         .map { Result<TournamentStatusModel, Error>.success($0) }
         .catch({ (error) -> AnyPublisher<Result<TournamentStatusModel, Error>, Never> in
             .just(Result<TournamentStatusModel, Error>.failure(error))
         })
         .flatMap({ [unowned self] (status: Result<TournamentStatusModel, Error>) -> AnyPublisher<Result<TournamentLeaderboardModel, Error>, Never> in
             switch status {
             case .success(let status):
                 return tournamentApi.requestLeadershipBoard(id: leaderboardId)
                     .map { Result<TournamentLeaderboardModel, Error>.success(leaderboard) }
                     .catch({ error -> AnyPublisher<Result<TournamentLeaderboardModel, Error>, Never> in
                         .just(Result<TournamentLeaderboardModel, Error>.failure(error))
                     })
                     .eraseToAnyPublisher()
             case .failure(let error):
                 return .just(Result<TournamentLeaderboardModel, Error>.failure(error))
             }
         })
         .eraseToAnyPublisher()
 }
 
 
 func buildGroupedBracketsWithResponse(
    _ response: TournamentLeaderboardModel
) -> [TournamentLeaderboardBracket: [TournamentLeaderboardUser]]? {
    guard let users = response.users, let brackets = response.brackets else { return nil }
    var groupedBrackets: [TournamentLeaderboardBracket: [TournamentLeaderboardUser]] = [:]
    brackets.forEach({ bracket in
        var bracketUsers = users.filter {
            if $0.bracketId.isNil { return false }
            return $0.bracketId == bracket.bracketId
        }
        var startIndex = bracketUsers.last?.rank == nil ? bracket.rankFrom : (bracketUsers.last!.rank!) + 1
        for _ in 0..<max((bracket.rankTill + 1) - bracket.rankFrom - bracketUsers.count, 0) {
            bracketUsers.append(TournamentLeaderboardUser.getEmptyUserRow(rank: startIndex, isChampionsBracket: bracket.rankFrom == 1))
            startIndex += 1
        }
        groupedBrackets[bracket] = bracketUsers
    })
    return groupedBrackets
 
 
 
}*/
