//
//  WebSocketClient.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 09.10.2021.
//

import Foundation
import Combine

protocol WebSocketConnectionType {
    var transmitter: AnyPublisher<WebSocketResult, Never> { get }
    func configure(withURL url: URL)
    func send(text: String)
    func send(data: Data)
    func connect()
    func disconnect()
}

enum WebSocketResult {
    case onConnected
    case onDisconnected
    case onError(error: Error)
    case onTextMessage(text: String)
    case onDataMessage(data: Data)
}

// MARK: - WebSocketClient

final class WebSocketClient: NSObject, WebSocketConnectionType { /// NSObject for URLSessionDelegate
    /// response spawner
    var transmitter: AnyPublisher<WebSocketResult, Never> {
        transmitterPipe.eraseToAnyPublisher()
    }
    
    private let transmitterPipe = PassthroughSubject<WebSocketResult, Never>()
    private var webSocketTask: URLSessionWebSocketTask?
    private lazy var urlSession = URLSession(configuration: .ephemeral, delegate: self, delegateQueue: sessionDelegateQueue)
    private lazy var sessionDelegateQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.qualityOfService = .utility
        return queue
    }()
    
    override init() {
        super.init()
    }
    
    func configure(withURL url: URL) {
        webSocketTask = urlSession.webSocketTask(with: url)
        listen()
    }
    
    func connect() {
        webSocketTask?.resume()
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }
    
    func send(text: String) {
        webSocketTask?.send(URLSessionWebSocketTask.Message.string(text)) { [weak self] error in
            guard let error = error else { return }
            self?.transmitterPipe.send(.onError(error: error))
        }
    }
    
    func send(data: Data) {
        webSocketTask?.send(URLSessionWebSocketTask.Message.data(data)) { [weak self] error in
            guard let error = error else { return }
            self?.transmitterPipe.send(.onError(error: error))
        }
    }
    
    private func listen()  {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                self?.transmitterPipe.send(.onError(error: error))
            case .success(let message):
                switch message {
                case .string(let text): self?.transmitterPipe.send(.onTextMessage(text: text))
                case .data(let data): self?.transmitterPipe.send(.onDataMessage(data: data))
                @unknown default: fatalError()
                }
                self?.listen()
            }
        }
    }
}

// MARK: - URLSessionWebSocketDelegate

extension WebSocketClient: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession,
                    webSocketTask: URLSessionWebSocketTask,
                    didOpenWithProtocol protocol: String?
    ) {
        transmitterPipe.send(.onConnected)
    }
    
    func urlSession(_ session: URLSession,
                    webSocketTask: URLSessionWebSocketTask,
                    didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
                    reason: Data?
    ) {
        transmitterPipe.send(.onDisconnected)
    }
}
