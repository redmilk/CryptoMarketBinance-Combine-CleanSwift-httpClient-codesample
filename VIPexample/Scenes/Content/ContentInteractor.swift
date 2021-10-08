//
//  ContentInteractor.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 10.05.2021.
//

import Combine

final class ContentInteractor: SceneInteractable {
    enum Response {
        case closePressed
        case character(MurvelResult?)
    }
    
    let inputFromController = PassthroughSubject<ContentViewController.Action, Never>()
    let outputToPresenter = PassthroughSubject<Response, Never>()
    
    private let marvelService = MarvelService()
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        let inputFromVC = inputFromController.share()
        inputFromVC.filter({ $0 == .closePressed })
            .map { _ in .closePressed }
            .subscribe(outputToPresenter)
            .store(in: &subscriptions)
        
        inputFromVC.sink(receiveValue: { [unowned self] action in
            switch action {
            case .willDisplayCellAtIndex(let index, let maxCount):
                if maxCount - 5 == index {
                    marvelService.requestMurvel()
                }
            case .closePressed: outputToPresenter.send(.closePressed)
            case _: break
            }
        })
        .store(in: &subscriptions)
        
        inputFromVC
            .filter { $0 == .loadCharacters }
            .handleEvents(receiveOutput: { [unowned self] _ in marvelService.requestMurvel() })
            .flatMap({ [unowned self] action -> AnyPublisher<Response, Never> in
                marvelService.murvels.flatMap({ chars -> AnyPublisher<MurvelResult, Never> in
                        Publishers.Sequence(sequence: chars)
                            .setFailureType(to: Never.self)
                            .eraseToAnyPublisher()
                    })
                    .map { Response.character($0) }
                    .eraseToAnyPublisher()
            })
            .subscribe(outputToPresenter)
            .store(in: &subscriptions)
    }
    deinit {
        Logger.log("ContentInteractor", type: .lifecycle)
    }
}
