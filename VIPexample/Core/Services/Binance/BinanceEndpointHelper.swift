//
//  BinanceEndpointHelper.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 09.10.2021.
//

import Foundation

fileprivate let wsBase = "wss://stream.binance.com:9443"

struct BinanceEndpointAssembler {
    
    func resolveEndpointBasedOnStreamsCount(_ streams: [String]) -> URL? {
        guard let firstElement = streams.first else { return nil }
        return streams.count > 1 ?
            self.getCombinedStreamsEndpoint(withStreamNames: streams) :
            self.getSingleStreamEndpoint(withStreamName: firstElement)
    }
    
    private func getSingleStreamEndpoint(withStreamName stream: String) -> URL? {
        URL(string: wsBase + "/ws/" + stream)
    }
    
    private func getCombinedStreamsEndpoint(withStreamNames streams: [String]) -> URL? {
        var urlComponents = URLComponents(string: wsBase + "/stream")
        let joined = streams.joined(separator: "/")
        urlComponents?.queryItems = [URLQueryItem(name: "streams", value: joined)]
        return URL(string: urlComponents?.url?.absoluteString ?? "")
    }
}
