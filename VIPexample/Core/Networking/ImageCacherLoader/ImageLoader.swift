//
//  ServicesContainer.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 28.07.2021.
//

import Combine
import UIKit.UIImage

protocol ImageLoaderType {
    func loadImage(withURL url: URL) -> AnyPublisher<UIImage?, Never>
    func loadImage(withURLString urlString: String?) -> AnyPublisher<UIImage?, Never>
}

struct ImageLoader: ImageLoaderType {
    
    private let cache: ImageCacher
    
    init(cache: ImageCacher) {
        self.cache = cache
    }
    
    // MARK: - API
    
    func loadImage(withURL url: URL) -> AnyPublisher<UIImage?, Never> {
        if let image = cache[url] {
            return .just(image)
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { data, response in UIImage(data: data) }
            .catch { _ in Just(nil) }
            .handleEvents(receiveOutput: { image in
                cache[url] = image
            })
            .eraseToAnyPublisher()
    }
    
    func loadImage(withURLString urlString: String?) -> AnyPublisher<UIImage?, Never> {
        guard let urlString = urlString,
              let url = URL(string: urlString) else {
            return .just(nil)
        }
        return loadImage(withURL: url)
    }
}
