//
//  AppDelegate.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 10.05.2021.
//

import UIKit
import Combine

@main
class AppDelegate: UIResponder, UIApplicationDelegate, BinanceServiceProvidable {

    var bag = Set<AnyCancellable>()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        binanceService.loadPrice(symbol: nil)
//            .sink(receiveCompletion: { completion in
//                switch completion {
//                case .failure(let error):
//                    Logger.log(error)
//                case .finished:
//                    break
//                }
//            }, receiveValue: { orderBook in
//                
//            })
//            .store(in: &bag)
//        
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

