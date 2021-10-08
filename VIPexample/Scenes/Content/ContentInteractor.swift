//
//  ContentInteractor.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 10.05.2021.
//

import Combine

struct ContentInteractor: InteractorType {
    enum Response {
        case closePressed
        case character(MurvelResult?)
    }
    
    let inputFromController = PassthroughSubject<ContentViewController.Action, Never>()
    let outputToPresenter = PassthroughSubject<Response, Never>()
    
    private let marvelService = MarvelService()
    private let bag: Set<AnyCancellable>
    
    init(bag: inout Set<AnyCancellable>) {
        self.bag = bag
        let inputFromVC = inputFromController.share()
        
        inputFromVC.filter({ $0 == .closePressed })
            .map { _ in .closePressed }
            .subscribe(outputToPresenter)
            .store(in: &bag)
        
        inputFromVC.sink(receiveValue: { [self] action in
            switch action {
            case .willDisplayCellAtIndex(let index, let maxCount):
                if maxCount - 5 == index {
                    marvelService.requestMurvel()
                }
            case .closePressed: outputToPresenter.send(.closePressed)
            case _: break
            }
        })
        .store(in: &bag)
        
        inputFromVC.filter { $0 == .loadCharacters }
            .handleEvents(receiveOutput: { [self] _ in marvelService.requestMurvel() })
            .flatMap({ [self] action -> AnyPublisher<Response, Never> in
                marvelService.murvels.flatMap({ chars -> AnyPublisher<MurvelResult, Never> in
                        Publishers.Sequence(sequence: chars)
                            .setFailureType(to: Never.self)
                            .eraseToAnyPublisher()
                    })
                    .map { Response.character($0) }
                    .eraseToAnyPublisher()
            })
            .subscribe(outputToPresenter)
            .store(in: &bag)
    }
}
