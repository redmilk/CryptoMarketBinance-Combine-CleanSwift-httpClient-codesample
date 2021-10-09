//
//  AppDelegate.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 10.05.2021.
//

import UIKit
import Combine

@main
class AppDelegate: UIResponder, UIApplicationDelegate, AllServicesProvidable {

    var bag = Set<AnyCancellable>()
    let queue = DispatchQueue(label: "Ticker", qos: .userInitiated)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        allServices.webSocket.configure(withURL: URL(string: "wss://stream.binance.com:9443/stream")!) ///BTC@aggTrade
        
        let msgModel = WSBinanceQuery(method: "SUBSCRIBE", params: ["!miniTicker@arr"], id: 1)
        let jsonQuery = try! JSONEncoder().encode(msgModel)
        let textQuery = String(data: jsonQuery, encoding: .utf8)!
        
        allServices.webSocket.connect()
        allServices.webSocket.send(text: textQuery)

        allServices.webSocket.transmitter
            .receive(on: queue)
            .sink(receiveValue: { result in
                switch result {
                case .onConnected(let connection):
                    Logger.log("Connected", type: .sockets)
                case .onDisconnected(let connection, let error):
                    Logger.log("Disconnected", type: .sockets)
                    Logger.log(error)
                case .onError(let connection, let error):
                    Logger.log(error)
                case .onTextMessage(let connection, let text):
                    let data = Data(text.utf8)
                    if let model = try? JSONDecoder().decode(WSAllMarketTicker.self, from: data) {
                        model.data.forEach { print(DateTimeHelper.convertIntervalToDateString($0.eventTime)) }
                    }
                case .onDataMessage(let connection, let data):
                    Logger.log(data)
                default:
                    fatalError("unexpected behaviour")
                }
            })
            .store(in: &bag)
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

