//
//  DateTimeHelper.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 09.10.2021.
//

import Foundation

enum DateTimeHelper {
    
    static func convertIntervalToDateString(
        _ timeIntervalMilliseconds: Int,
        withFormatting format: String = "hh:mm:ss"
    ) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timeIntervalMilliseconds / 1000))
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = .current
        return formatter.string(from: date)
    }
    
}
