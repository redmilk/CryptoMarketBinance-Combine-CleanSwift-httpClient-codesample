//
//  ServicesContainer.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 28.07.2021.
//

import Foundation

fileprivate let services = ServicesContainer()

final class ServicesContainer {
    
    private lazy var httpClient: HTTPClient = {
        let urlSession = URLSession(configuration: .ephemeral)
        let httpClient = HTTPClient(session: urlSession, isAuthorizationRequired: false)
        return httpClient
    }()
    
    lazy var imageCacher: ImageCacher = {
        let config = ImageCacher.Config(countLimit: 1000, memoryLimit: 1024 * 1024 * 300) /// 300 mb
        let imageCacher = ImageCacher(config: config)
        return imageCacher
    }()
    
    lazy var binanceService: BinanceService = {
        let binanceApi = BinanceApi(httpClient: httpClient)
        return BinanceService(binanceApi: binanceApi)
    }()
    
    lazy var imageLoader: ImageLoader = { ImageLoader(cache: imageCacher) }()
}

// MARK: - add specific service dependency to object

/// Binance API Service
protocol BinanceServiceProvidable { }
extension BinanceServiceProvidable {
    var binanceService: BinanceService { services.binanceService }
}

/// ImageLoader Service
protocol ImageLoaderProvidable { }
extension ImageLoaderProvidable {
    var imageLoader: ImageLoader { services.imageLoader }
}

// MARK: - if you want to include all services to object

/// All services
protocol AllServicesProvidable { }
extension AllServicesProvidable {
    var allServices: ServicesContainer { services }
}
