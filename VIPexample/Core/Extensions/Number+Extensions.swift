//
//  Number+Extensions.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 09.10.2021.
//

import Foundation

extension Double {
    func removeZerosFromEnd(maxZerosCount: Int) -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = maxZerosCount
        return String(formatter.string(from: number) ?? "")
    }
}
