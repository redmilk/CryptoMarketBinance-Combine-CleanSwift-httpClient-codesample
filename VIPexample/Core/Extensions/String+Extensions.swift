//
//  Number+Extensions.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 09.10.2021.
//

import Foundation

extension String {
    var withoutTrailingZeros: String {
        var initial = String(self)
        while (initial.last == "0" || initial.last == ".") {
            initial = String(initial.dropLast())
        }
        return initial
    }
}


