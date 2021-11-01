//
//  ContentInteractor.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 10.05.2021.
//

import Combine

final class ContentInteractor: InputOutputable {
    typealias Failure = Never
    
    enum Response {
        case showAuth
        case character(MurvelResult?)
    }
    
    let input = PassthroughSubject<ContentViewController.Action, Never>()
    var output: AnyPublisher<Response, Never> { _output.eraseToAnyPublisher() }
    
    private let presenter: ContentPresenter
    private let _output = PassthroughSubject<Response, Never>()
    private let marvelService = MarvelService()
    private var bag = Set<AnyCancellable>()
    
    init(presenter: ContentPresenter) {
        self.presenter = presenter
        input.sink(receiveValue: { [unowned self] action in
            switch action {
            case .willDisplayCellAtIndex(let index, let maxCount):
                if maxCount - 5 == index {
                    marvelService.requestMurvel()
                }
            case .showAuth:
                _output.send(.showAuth)
            case _: break
            }
        })
        .store(in: &bag)
        
        input.filter { $0 == .loadCharacters }
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
            .subscribe(_output)
            .store(in: &bag)
    }
    deinit {
        Logger.log(String(describing: self), type: .deinited)
    }
}
