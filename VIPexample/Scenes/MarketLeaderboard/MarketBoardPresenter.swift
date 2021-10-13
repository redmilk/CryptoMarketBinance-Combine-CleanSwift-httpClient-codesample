//
//  
//  MarketBoardPresenter.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 12.10.2021.
//
//

import Combine
import Foundation

struct MarketBoardPresenter: PresenterType {

    let inputFromInteractor = PassthroughSubject<MarketBoardInteractor.Response, Never>()
    let outputToViewController = PassthroughSubject<MarketBoardViewController.State, Never>()
    
    private let coordinator: CoordinatorType
    private var bag = Set<AnyCancellable>()
    
    init(coordinator: CoordinatorType) {
        self.coordinator = coordinator
        bindInputOutput()
    }
}

// MARK: Internal

private extension MarketBoardPresenter {
    
    mutating func bindInputOutput() {
        inputFromInteractor
            .map { interactorResponse in
                switch interactorResponse {
                case .dummy: return .newData(MarketBoardSectionModel(title: "", rewardAmount: "", isChampionsBracket: false, users: []))
                }
            }
            .subscribe(outputToViewController)
            .store(in: &bag)
    }
}
