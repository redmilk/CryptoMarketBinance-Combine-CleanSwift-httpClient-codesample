//
//  BinanceSocketAPI.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 09.10.2021.
//

import Foundation
import Combine

// MARK: - Interface

protocol BinanceSocketApiType {
    var streamResponse: AnyPublisher<BinanceSocketApi.SocketResponse, Never> { get }
    func updateStreams(updateType: BinanceSocketApi.StreamUpdateMethod, forStreams streams: [String])
    func configure(withSingleOrMultipleStreams streams: [String])
    func reconnect()
    func connect()
    func disconnect()
}

// MARK: - Helper Types

extension BinanceSocketApi {
    enum SocketResponse {
        case connected
        case disconnected
        case error(BinanceServiceError)
        case message(String)
    }
    enum StreamUpdateMethod: String {
        case subscribe = "SUBSCRIBE"
        case unsubscribe = "UNSUBSCRIBE"
    }
}

// MARK: - BinanceSocketAPI

final class BinanceSocketApi: BinanceSocketApiType {
    
    var streamResponse: AnyPublisher<SocketResponse, Never> {
        streamResponsePipe.eraseToAnyPublisher()
    }
    
    private let streamResponsePipe = PassthroughSubject<SocketResponse, Never>()
    private let endpointAssambler = BinanceEndpointAssembler()
    private let serialQueue = DispatchQueue(label: "SocketsQueue", qos: .userInitiated)
    private let socketClient = WebSocketClient()
    private var currentStreamSettings = Set<String>() /// cached current stream params for reconnect
    private var bag = Set<AnyCancellable>()
    
    init() {
        dispatchSocketResponse()
    }
    
    func updateStreams(
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
        currentStreamSettings = Set(streams)
        socketClient.send(text: requestString)
    }
    
    func configure(withSingleOrMultipleStreams streams: [String]) {
        guard let url = endpointAssambler.resolveEndpointBasedOnStreamsCount(streams) else {
            streamResponsePipe.send(.error(BinanceServiceError.emptyStreamNames(description: "There is not any stream symbol inside parameters array")))
            return
        }
        currentStreamSettings = Set(streams)
        socketClient.configure(withURL: url)
    }
    
    func reconnect() {
        guard let url = endpointAssambler.resolveEndpointBasedOnStreamsCount(Array(currentStreamSettings)) else {
            streamResponsePipe.send(.error(BinanceServiceError.emptyStreamNames(description: "There is not any stream symbol inside parameters array")))
            return
        }
        socketClient.configure(withURL: url)
        socketClient.connect()
    }
    
    func connect() {
        socketClient.connect()
    }
    
    func disconnect() {
        socketClient.disconnect()
    }
}

// MARK: - Private

private extension BinanceSocketApi {
    
    func updateCurrentStreamSettingsCache(
        withUpdateMethod method: StreamUpdateMethod,
        streamParams: [String]
    ) {
        switch method {
        case .subscribe:
            streamParams.forEach { currentStreamSettings.insert($0) }
        case .unsubscribe:
            streamParams.forEach { currentStreamSettings.remove($0) }
        }
    }
    
    func dispatchSocketResponse() {
        socketClient.transmitter
            .receive(on: serialQueue)
            .sink(receiveValue: { [weak self] result in
                switch result {
                case .onConnected:
                    self?.streamResponsePipe.send(.connected)
                case .onDisconnected:
                    self?.streamResponsePipe.send(.disconnected)
                case .onError(let error):
                    self?.streamResponsePipe.send(.error(BinanceServiceError.websocketClient(error: error)))
                case .onTextMessage(let text):
                    self?.streamResponsePipe.send(.message(text))
                case .onDataMessage(_):
                    fatalError("did not expect to recieve Data")
                }
            })
            .store(in: &bag)
    }
}
