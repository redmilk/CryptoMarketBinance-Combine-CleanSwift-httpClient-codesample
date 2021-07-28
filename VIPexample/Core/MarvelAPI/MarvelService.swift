//
//  MarvelAPI.swift
//  VIPexample
//
//  Created by Admin on 10.05.2021.
//

import Foundation
import CryptoKit
import Combine
import UIKit.UIImage
// public 3a1e3fc927630d93c59119f347c5bd2e
// private 81ce12839574a4ca97c41a2cb119083ad101f1e5

func MD5(ts: String) -> String {
    let hash = "\(ts)81ce12839574a4ca97c41a2cb119083ad101f1e53a1e3fc927630d93c59119f347c5bd2e"
    let digest = Insecure.MD5.hash(data: hash.data(using: .utf8) ?? Data())
    return digest.map {
        String(format: "%02hhx", $0)
    }.joined()
}

enum MarvelRequestError: Error {
    case urlError(error: URLError)
    case parsingError(error: DecodingError)
}

final class MarvelService {
    var murvels = CurrentValueSubject<Set<MurvelResult>, Never>([])
    
    private let baseURL = URL(string: "https://gateway.marvel.com")!
    private var subscriptions = Set<AnyCancellable>()
    private var offset: Int = 0
        
    func requestMurvel() {
        let ts = Date().currentTimeMillis()
        let md5 = MD5(ts: ts)
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)!
        components.queryItems = [URLQueryItem(name: "ts", value: ts),
                                 URLQueryItem(name: "apikey", value: "3a1e3fc927630d93c59119f347c5bd2e"),
                                 URLQueryItem(name: "hash", value: md5),
                                 URLQueryItem(name: "limit", value: "100"),
                                 URLQueryItem(name: "offset", value: offset.description)]
        components.path = "/v1/public/characters"
        var request = URLRequest(url: components.url(relativeTo: baseURL)!)
        request.httpMethod = "GET"
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .compactMap { $0.data }
            .decode(type: Murvel.self, decoder: JSONDecoder())
            .compactMap { $0.data?.results }
            .flatMap({ results -> AnyPublisher<MurvelResult, Error> in
                Publishers.Sequence(sequence: results)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            })
            .flatMap({ [unowned self] char -> AnyPublisher<MurvelResult?, Error>  in
                let url = URL(string: char.thumbnail!.path! + "/portrait_uncanny." + char.thumbnail!.thumbnailExtension!)!
                guard !url.absoluteString.contains("image_not_available") else {
                    self.offset += 1
                    return Just(nil).setFailureType(to: Error.self).eraseToAnyPublisher()
                }
                return URLSession.shared.dataTaskPublisher(for: url)
                    .mapError({ $0 })
                    .compactMap { UIImage(data: $0.data) }
                    .combineLatest(Just(char).setFailureType(to: Error.self).eraseToAnyPublisher())
                    .map({ image, char in
                        var char = char
                        char.image = image
                        return char
                    })
                    .eraseToAnyPublisher()
            })
            .compactMap { $0 }
            .sink(receiveCompletion: { [unowned self] completion in
                //requestMurvel()
            }, receiveValue: { [unowned self] char in
                murvels.send([char])
                offset += 1
            })
            .store(in: &subscriptions)
    }
}


extension Date {
    func currentTimeMillis() -> String {
        return Int64(self.timeIntervalSince1970 * 1000).description
    }
}
