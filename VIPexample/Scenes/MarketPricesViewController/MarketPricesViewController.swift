//
//  
//  MarketPricesViewController.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 09.10.2021.
//
//

import UIKit
import Combine
import SpriteKit
import Magnetic

// MARK: - ImageNode
class ImageNode: Node {
    override var image: UIImage? {
        didSet {
            texture = image.map { SKTexture(image: $0) }
        }
    }
    override func selectedAnimation() {}
    override func deselectedAnimation() {}
}

// MARK: - ViewController State and Actions types

extension MarketPricesViewController {
    enum State {
        case recievedResponseModel(CommonSymbolTickerType?)
        case updateSocketStatus(String, shouldClean: Bool)
        case failure(errorMessage: String)
        case clear
    }
    enum Action {
        case configureSockets([String])
        case connect
        case disconnect
        case addStream([String])
        case removeStream([String])
        case reconnect
    }
}

// MARK: - MarketPricesViewController

final class MarketPricesViewController: UIViewController, ViewControllerType {
    
    @IBOutlet weak var magneticView: MagneticView! {
        didSet {
            magnetic.magneticDelegate = self
            magnetic.removeNodeOnLongPress = true
            magnetic.scene?.backgroundColor = .clear
            #if DEBUG
            magneticView.showsFPS = true
            magneticView.showsDrawCount = true
            magneticView.showsQuadCount = true
            magneticView.showsPhysics = true
            #endif
        }
       }
    
    var magnetic: Magnetic {
            return magneticView.magnetic
        }
    
    @IBOutlet weak var mainTextView: UITextView!
    @IBOutlet weak var debugTextView: UITextView!
    @IBOutlet weak var updateStreamTextField: UITextField!
    
    @IBOutlet weak var configureButton: UIButton!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var disconnectButton: UIButton!
    @IBOutlet weak var newStreamButton: UIButton!
    @IBOutlet weak var removeStreamButton: UIButton!
    @IBOutlet weak var reconnectButton: UIButton!
        
    let inputFromPresenter = PassthroughSubject<State, Never>()
    let outputToInteractor = PassthroughSubject<Action, Never>()

    private var bag: Set<AnyCancellable>!
    
    init() {
        super.init(nibName: String(describing: MarketPricesViewController.self), bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dispatchActionsForInteractor()
        subscribePresenterOutput()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        for _ in 0..<12 {
//            add(nil)
//        }
//    }
    
    func storeSubscriptions(_ bag: inout Set<AnyCancellable>) {
        self.bag = bag
    }
    
    @IBAction func add(_ sender: UIControl?) {
//        let color = UIColor.colors.randomItem()
//        let node = Node(text: name.capitalized, color: color, radius: 40)
//        node.scaleToFitContent = true
//        node.selectedColor = UIColor.colors.randomItem()
//        magnetic.addChild(node)
//
        // Image Node: image displayed by default
        // let node = ImageNode(text: name.capitalized, image: UIImage(named: name), color: color, radius: 40)
        // magnetic.addChild(node)
    }
    
    @IBAction func reset(_ sender: UIControl?) {
            magneticView.magnetic.reset()
        }
    
    private func addBubble(tuple: (String, String, String)) {
        let name = UIImage.names.randomItem()
        let color = UIColor.colors.randomItem()
        let node = Node(text: name.capitalized, image: UIImage(named: name), color: color, radius: 40)
        node.label.verticalAlignmentMode = .center
        node.text = tuple.0 + " \n" + tuple.1 + " \n" + tuple.2 + " \n"
        node.fontColor = .black
        //node.fontSize = CGFloat(Int.random(in: 10...30))!
        node.scaleToFitContent = true
        node.selectedColor = UIColor.colors.randomItem()
        magnetic.addChild(node)
    }
}

// MARK: - MagneticDelegate
extension MarketPricesViewController: MagneticDelegate {
    
    func magnetic(_ magnetic: Magnetic, didSelect node: Node) {
        print("didSelect -> \(node)")
    }
    
    func magnetic(_ magnetic: Magnetic, didDeselect node: Node) {
        print("didDeselect -> \(node)")
    }
    
    func magnetic(_ magnetic: Magnetic, didRemove node: Node) {
        print("didRemove -> \(node)")
    }
}

// MARK: - ViewController Input-Output

private extension MarketPricesViewController {
    
    func dispatchActionsForInteractor() {
        /// Sending actions to Interactor
        let configure = configureButton.publisher(for: .touchUpInside)
            .compactMap { [weak self] _ in self?.updateStreamTextField.text?.components(separatedBy: [" "]).filter { !$0.isEmpty } }
            .map { Action.configureSockets($0) }
        let connect = connectButton.publisher(for: .touchUpInside).map { _ in Action.connect }
        let disconnect = disconnectButton.publisher(for: .touchUpInside).map { _ in Action.disconnect }
        let reconnect = reconnectButton.publisher(for: .touchUpInside).map { _ in Action.reconnect }
        let textFieldValues = updateStreamTextField.publisher(for: .editingChanged)
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .compactMap { $0.text?.components(separatedBy: [" "]).filter { !$0.isEmpty } }
        let newStreamAdd = newStreamButton.publisher(for: .touchUpInside)
            .combineLatest(textFieldValues)
            .map { Action.addStream($0.1) }
        let removeStream = removeStreamButton.publisher(for: .touchUpInside)
            .combineLatest(textFieldValues)
            .map { Action.removeStream($0.1) }
        Publishers.Merge6(configure, connect, disconnect, reconnect, newStreamAdd, removeStream)
            .sink(receiveValue: { [weak self] in self?.outputToInteractor.send($0) })
            .store(in: &bag)
    }
        
    func subscribePresenterOutput() {
        /// Recieve Presenter's output
        inputFromPresenter
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] state in
                switch state {
                case .recievedResponseModel(let model):
                    guard let model = model else { return }
                    switch model {
                    case .singleSymbol(let singleSymbolModel):
                        print((singleSymbolModel.symbol ?? "") + " " + (singleSymbolModel.priceChangePercent ?? "") + "%")
                        self?.mainTextView.text += "\t" + (singleSymbolModel.symbol ?? "") + " " + (singleSymbolModel.lastPriceFormatted ?? "")
                    case .multipleSymbols(let multipleSymbolModel):
                        print((multipleSymbolModel.data.symbol ?? "") + " " + (multipleSymbolModel.data.priceChangePercent ?? "") + "%")
                        self?.mainTextView.text += "\t" + (multipleSymbolModel.data.symbol ?? "") + " " + (multipleSymbolModel.data.lastPriceFormatted ?? "")
                    case .marketMiniTicker(let marketMini):
                        let tuples = marketMini
                            .filter { $0.symbol.contains("USDT") }
                            .map { ($0.symbol, $0.closeFormatted, $0.quantity) }
                            .eraseToAnyPublisher()
                        let pub = tuples
                            .handleEvents(receiveOutput: { tuple in
                                self?.mainTextView.text += "\t" + tuple.0 + " " + tuple.1
                            })
                            .publisher.prefix(5)
                            .receive(on: DispatchQueue.main)
                            .eraseToAnyPublisher()
                        
                        var cancellable: AnyCancellable?
                        cancellable = pub.sink(receiveCompletion: { _ in
                            cancellable?.cancel()
                        }) { tuples in
                            self?.addBubble(tuple: tuples)
                        }
                    }
                    let range = NSMakeRange(self?.mainTextView.text.count ?? 0 - 1, 0)
                    self?.mainTextView.scrollRangeToVisible(range)
                case .updateSocketStatus(let socketStatus, let shouldClean):
                    self?.debugTextView.text = socketStatus
                    shouldClean ? self?.mainTextView.text = nil : ()
                    Logger.log(socketStatus, type: .sockets)
                case .failure(let errorMessage):
                    self?.debugTextView.text = errorMessage
                case .clear:
                    self?.mainTextView.text = nil
                }
            })
            .store(in: &bag)
    }
}
