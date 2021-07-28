//
//  AuthTokens.swift
//  Clawee
//
//  Created by Danyl Timofeyev on 07.05.2021.
//  Copyright © 2021 Noisy Miner. All rights reserved.
//

import Foundation

// MARK: - Refresh token response model

struct AuthTokens: Codable {
    /// backend properties
    var accessToken: String?
    var firebaseToken: String?
    var expiresIn: Int? {
        didSet {
            tokenExpirationDate = expirationDate
        }
    }
    /// extra properties
    var refreshToken: String?
    var tokenExpirationDate: Date?
    var isExpired: Bool? {
        guard let expirationDate = expirationDate else { return nil }
        return Date() > expirationDate
    }
    
    private var expirationDate: Date? {
        guard let expiresIn = expiresIn else { return nil }
        let currentDateInterval = Date().timeIntervalSince1970
        let expirationDateInterval = currentDateInterval + Double(expiresIn) / 1000.0
        return Date(timeIntervalSince1970: expirationDateInterval)
    }
    
    init(accessToken: String? = nil,
         expiresIn: Int? = nil,
         tokenExpirationDate: Date? = nil,
         refreshToken: String? = nil,
         firebaseToken: String? = nil
    ) {
        self.accessToken = accessToken
        self.expiresIn = expiresIn
        self.refreshToken = refreshToken
        self.firebaseToken = firebaseToken
    }
    
    mutating func update(withRefreshTokenRequestResponse tokens: AuthTokens) {
        accessToken = tokens.accessToken
        firebaseToken = tokens.firebaseToken
        expiresIn = tokens.expiresIn
    }
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "accessToken"
        case expiresIn = "expiresIn"
        case firebaseToken = "firebaseToken"
    }
}
