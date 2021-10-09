//
//  BinanceSocketAPI.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 09.10.2021.
//

import Foundation
import Combine

enum BinanceSocketResponse {
    case connected
    case disconnected(Error?)
    case error(Error)
    case message(String)
}

protocol StreamTickElement {
    
}

final class BinanceSocketAPI {
    
    enum StreamUpdateMethod: String {
        case subscribe = "SUBSCRIBE"
        case unsubscribe = "UNSUBSCRIBE"
    }
    
    let streamMessagePipe = PassthroughSubject<StreamTickElement, Never>()
    let streamServicePipe = PassthroughSubject<StreamTickElement, Never>()
    
    private var bag = Set<AnyCancellable>()
    private let serialQueue = DispatchQueue(label: "SocketsQueue", qos: .userInitiated)
    private let socketClient = WebSocketClient()
    private var currentStreamSettings: [String] = [] /// for reconnect
    
    init() {
        dispatchSocketResponse()
        socketClient.connect()
    }
    
    func configure(withSingleOrMultipleStreams streams: [String]) {
        let url = BinanceEndpointAssembler.resolveEndpointBasedOnStreamsCount(streams)
        socketClient.configure(withURL: url)
    }
    
    func reconnect() {
        
    }
    
    func disconnect() {
        
    }
    
    func updateWhatWeWantToListen(
        updateType: StreamUpdateMethod,
        forStreams streams: [String]
    ) {
        let request = WSBinanceQuery(
            method: updateType.rawValue,
            params: streams,
            id: Int.random(in: 1...9999999)
        )
        let jsonQuery = try! JSONEncoder().encode(request)
        let requestString = String(data: jsonQuery, encoding: .utf8)!
        socketClient.send(text: requestString)
    }
    
    private func dispatchSocketResponse() {
        socketClient.transmitter
            .receive(on: serialQueue)
            .sink(receiveValue: { result in
                switch result {
                case .onConnected: Logger.log("Connected", type: .sockets)
                case .onDisconnected(let error): Logger.log("Disconnected", type: .sockets)
                    Logger.log(error)
                case .onError(let connection, let error):
                    Logger.log(error)
                case .onTextMessage(let connection, let text):
                    
//                    let data = Data(text.utf8)
//                    if let model = try? JSONDecoder().decode(WSAllMarketTicker.self, from: data) {
//                        model.data.forEach { print(DateTimeHelper.convertIntervalToDateString($0.eventTime)) }
//                    }
                case .onDataMessage(let connection, let data): break
                default: fatalError("unexpected behaviour")
                }
            })
            .store(in: &bag)
    }
}
