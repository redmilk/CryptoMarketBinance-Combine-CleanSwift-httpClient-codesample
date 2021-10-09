//
//  WebSocketClient.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 09.10.2021.
//

import Foundation
import Combine

protocol WebSocketConnection {
    var transmitter: PassthroughSubject<WebSocketResult, Never> { get }
    
    func configure(withURL url: URL)
    func send(text: String)
    func send(data: Data)
    func connect()
    func disconnect()
}

enum WebSocketResult {
    case onConnected(connection: WebSocketConnection)
    case onDisconnected(connection: WebSocketConnection, error: Error?)
    case onError(connection: WebSocketConnection, error: Error)
    case onMessage(connection: WebSocketConnection, text: String)
    case onMessage(connection: WebSocketConnection, data: Data)
}

/// NSObject needed for URLSessionDelegate
final class WebSocketClient: NSObject, WebSocketConnection {
    var transmitter = PassthroughSubject<WebSocketResult, Never>()
    
    private var webSocketTask: URLSessionWebSocketTask!
    private lazy var urlSession = URLSession(configuration: .ephemeral, delegate: self, delegateQueue: sessionDelegateQueue)
    private lazy var sessionDelegateQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.qualityOfService = .userInitiated
        return queue
    }()
    
    override init() {
        super.init()
    }
    
    func configure(withURL url: URL) {
        webSocketTask = urlSession.webSocketTask(with: url)
    }
    
    func connect() {
        webSocketTask.resume()
        listen()
    }
    
    func disconnect() {
        webSocketTask.cancel(with: .goingAway, reason: nil)
    }
    
    func listen()  {
        webSocketTask.receive { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                self.transmitter.send(.onError(connection: self, error: error))
            case .success(let message):
                switch message {
                case .string(let text): self.transmitter.send(.onMessage(connection: self, text: text))
                case .data(let data): self.transmitter.send(.onMessage(connection: self, data: data))
                @unknown default: fatalError()
                }
                self.listen()
            }
        }
    }
    
    func send(text: String) {
        webSocketTask.send(URLSessionWebSocketTask.Message.string(text)) { [weak self] error in
            guard let self = self, let error = error else { return }
            self.transmitter.send(.onError(connection: self, error: error))
        }
    }
    
    func send(data: Data) {
        webSocketTask.send(URLSessionWebSocketTask.Message.data(data)) { [weak self] error in
            guard let self = self, let error = error else { return }
            self.transmitter.send(.onError(connection: self, error: error))
        }
    }
}

// MARK: - URLSessionWebSocketDelegate

extension WebSocketClient: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession,
                    webSocketTask: URLSessionWebSocketTask,
                    didOpenWithProtocol protocol: String?
    ) {
        transmitter.send(.onConnected(connection: self))
    }
    
    func urlSession(_ session: URLSession,
                    webSocketTask: URLSessionWebSocketTask,
                    didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
                    reason: Data?
    ) {
        transmitter.send(.onDisconnected(connection: self, error: nil))
    }
}
