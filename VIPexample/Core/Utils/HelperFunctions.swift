//
//  ExpirationTimeString.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 29.07.2021.
//

import Foundation

enum TimeFormatting {
    case timeSymbols(shouldDisplayThreePlaceholders: Bool)
    case daysToHours(shouldDisplayThreePlaceholders: Bool)
}

func makeExpirationTimeString(
    withMillisecondsTimeInterval interval: TimeInterval,
    shouldDisplayTimeSymbols: Bool = true,
    shouldConvertDaysIntoHours: Bool = false,
    shouldDisplayThreePlaceholders: Bool = false
) -> String {
    let days = Int(interval) / 86400
    let hours = Int(interval) / 3600 % 24
    let minutes = Int(interval) / 60 % 60
    let seconds = Int(interval) % 60
    let hoursTotal = (days * 24 + hours)
    let hasDays = days >= 1
    let hasHours = hours >= 1
    
    let daysMoreThanOneWithDaysReplacing = shouldDisplayThreePlaceholders ?
        String(format: shouldDisplayTimeSymbols ? "%02ih:%02im:%02is" : "%02i:%02i:%02i", hoursTotal, minutes, seconds) :
        String(format: shouldDisplayTimeSymbols ?  "%02ih:%02im" : "%02i:%02i", hoursTotal, minutes)
    let daysMoreThanOneNoDaysReplacing = shouldDisplayThreePlaceholders ?
        String(format: shouldDisplayTimeSymbols ? "%02id:%02ih:%02is" : "%02i:%02i:%02i", days, hours, seconds) :
        String(format: shouldDisplayTimeSymbols ? "%02id:%02ih" : "%02i:%02i", days, hours)
    let hoursMoreThanOne = shouldDisplayThreePlaceholders ?
        String(format: shouldDisplayTimeSymbols ? "%02ih:%02im:%02is" : "%02i:%02i:%02i", hours, minutes, seconds) :
        String(format: shouldDisplayTimeSymbols ? "%02ih:%02im" : "%02i:%02i", hours, minutes)
    let hoursLessThanOne = shouldDisplayThreePlaceholders ?
        String(format: shouldDisplayTimeSymbols ?  "%02ih:%02im:%02is" : "%02i:%02i:%02i", hours, minutes, seconds) :
        String(format: shouldDisplayTimeSymbols ?  "%02im:%02is" : "%02i:%02i", minutes, seconds)
    
    let resultWithDays = shouldConvertDaysIntoHours ? daysMoreThanOneWithDaysReplacing : daysMoreThanOneNoDaysReplacing
    let resultWithHours = hasHours ? hoursMoreThanOne : hoursLessThanOne
    
    return hasDays ? resultWithDays : resultWithHours
}
