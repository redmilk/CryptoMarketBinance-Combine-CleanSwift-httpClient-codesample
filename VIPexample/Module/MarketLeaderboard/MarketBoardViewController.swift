//
//  
//  MarketBoardViewController.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 12.10.2021.
//
//

import UIKit
import Combine

// MARK: - view controller State and Actions types

extension MarketBoardViewController {
    enum State {
        case loading
        case newData([MarketBoardSectionModel])
    }
    enum Action {
        case shouldStartStream
        case shouldDisconnect
        case displayDebug
        case displayMarvel
        case displayAuth
    }
    enum BarButton: String {
        case debug = "Debug"
        case marvel = "Marvel"
        case auth = "Auth as Root"
    }
}

// MARK: - MarketBoardViewController

final class MarketBoardViewController: UIViewController, InputOutputable {
    typealias Failure = Never
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    let input = PassthroughSubject<State, Never>()
    var output: AnyPublisher<Action, Never> { _output.eraseToAnyPublisher() }
    
    private let interactor: MarketBoardInteractor
    private let _output = PassthroughSubject<Action, Never>()
    private var bag: Set<AnyCancellable>!
    private lazy var dataManager = MarketBoardDisplayManager(collectionView: collectionView)

    init(interactor: MarketBoardInteractor) {
        #warning("Refactor to protocol")
        self.interactor = interactor
        super.init(nibName: String(describing: MarketBoardViewController.self), bundle: nil)
    }
    deinit {
        Logger.log(String(describing: self), type: .deinited)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        handleInput()
        dataManager.configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _output.send(.shouldStartStream)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        _output.send(.shouldDisconnect)
    }
    
    func setupWithDisposableBag(_ bag: Set<AnyCancellable>) {
        self.bag = bag
    }
    
    /// handleInput
    func handleInput() {
        input.receive(on: DispatchQueue.main)
            .sink(receiveValue: { [unowned self] state in
            switch state {
            case .loading:
                activityIndicator.startAnimating()
            case .newData(let sections):
                activityIndicator.stopAnimating()
                dataManager.update(withSections: sections)
            }
        })
        .store(in: &bag)
    }
    
    private func configureView() {
        let debugScene = UIBarButtonItem(title: BarButton.debug.rawValue, style: .plain, target: nil, action: nil)
        let marvelScene = UIBarButtonItem(title: BarButton.marvel.rawValue, style: .plain, target: nil, action: nil)
        let authScene = UIBarButtonItem(title: BarButton.auth.rawValue, style: .plain, target: nil, action: nil)

        Publishers.Merge3(debugScene.publisher(),
                          marvelScene.publisher(),
                          authScene.publisher()
        )
        .sink(receiveValue: { [unowned _output] sender in
            switch BarButton(rawValue: sender.title!)! {
            case .debug: _output.send(.displayDebug)
            case .marvel: _output.send(.displayMarvel)
            case .auth: _output.send(.displayAuth)
            }
        })
        .store(in: &bag)
                
        let toolbar = DarkToolBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        toolbar.widthAnchor.constraint(equalToConstant: 150).isActive = true
        let rightSpacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let leftSpacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([leftSpacer, authScene, rightSpacer], animated: false)
        
        navigationItem.rightBarButtonItem = debugScene
        navigationItem.leftBarButtonItem = marvelScene
        navigationItem.titleView = toolbar
    }
}
