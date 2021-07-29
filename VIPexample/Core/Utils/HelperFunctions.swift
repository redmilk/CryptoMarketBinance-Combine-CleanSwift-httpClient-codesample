//
//  ExpirationTimeString.swift
//  VIPexample
//
//  Created by Danyl Timofeyev on 29.07.2021.
//

import Foundation

enum TimeFormatting {
    
    /// 01d:01h:01s
    case threePartsLong(shouldReplaceDays: Bool)
    
    /// 01:01:01
    case threePartsShort(shouldReplaceDays: Bool)
    
    /// 01d:01h
    case twoPartsLong(shouldReplaceDays: Bool)
    
    /// 01:01
    case twoPartsShort(shouldReplaceDays: Bool)
}

func makeExpirationTimeStringAlt(
    withMillisecondsTimeInterval interval: TimeInterval,
    withTimeFormatting formatting: TimeFormatting
) -> String {
    let days = Int(interval) / 86400
    let hours = Int(interval) / 3600 % 24
    let minutes = Int(interval) / 60 % 60
    let seconds = Int(interval) % 60
    let hoursTotal = (days * 24 + hours)
    
    switch formatting {
    case .threePartsLong(let daysToHours):
        return formatTime(isLong: true, hasThreeParts: true, convertDaysToHours: daysToHours, days: days, hoursTotal: hoursTotal, hours: hours, minutes: minutes, seconds: seconds)
    case .threePartsShort(let daysToHours):
        return formatTime(isLong: false, hasThreeParts: true, convertDaysToHours: daysToHours, days: days, hoursTotal: hoursTotal, hours: hours, minutes: minutes, seconds: seconds)
    case .twoPartsLong(let daysToHours):
        return formatTime(isLong: true, hasThreeParts: false, convertDaysToHours: daysToHours, days: days, hoursTotal: hours, hours: hours, minutes: minutes, seconds: seconds)
    case .twoPartsShort(let daysToHours):
        return formatTime(isLong: false, hasThreeParts: false, convertDaysToHours: daysToHours, days: days, hoursTotal: hours, hours: hours, minutes: minutes, seconds: seconds)
    }
}

private func formatTime(isLong: Bool, hasThreeParts: Bool, convertDaysToHours: Bool, days: Int, hoursTotal: Int, hours: Int, minutes: Int, seconds: Int) -> String {
    /// days >= 1
    func formatWhenDaysMoreThanOne(isLong: Bool, hasThreeParts: Bool, convertDaysToHours: Bool, days: Int, hoursTotal: Int, hours: Int, minutes: Int, seconds: Int) -> String {
        let daysConvertedToHours = hasThreeParts ?
            String(format: isLong ? "%02ih:%02im:%02is" : "%02i:%02i:%02i", hoursTotal, minutes, seconds) :
            String(format: isLong ?  "%02ih:%02im" : "%02i:%02i", hoursTotal, minutes)
        let noDaysConversion = hasThreeParts ?
            String(format: isLong ? "%02id:%02ih:%02is" : "%02i:%02i:%02i", days, hours, minutes) :
            String(format: isLong ? "%02id:%02ih" : "%02i:%02i", days, hours)
        return convertDaysToHours ? daysConvertedToHours : noDaysConversion
    }
    /// days < 1
    func formatWhenDaysLessThanOne(isLong: Bool, hasThreeParts: Bool, days: Int, hours: Int, minutes: Int, seconds: Int) -> String {
        let hoursMoreThanOne = hasThreeParts ?
            String(format: isLong ? "%02ih:%02im:%02is" : "%02i:%02i:%02i", hours, minutes, seconds) :
            String(format: isLong ? "%02ih:%02im" : "%02i:%02i", hours, minutes)
        let hoursLessThanOne = hasThreeParts ?
            String(format: isLong ?  "%02ih:%02im:%02is" : "%02i:%02i:%02i", hours, minutes, seconds) :
            String(format: isLong ?  "%02im:%02is" : "%02i:%02i", minutes, seconds)
        return hours >= 1 ? hoursMoreThanOne : hoursLessThanOne
    }
    
    let daysMoreThanOne = formatWhenDaysMoreThanOne(isLong: isLong, hasThreeParts: hasThreeParts, convertDaysToHours: convertDaysToHours, days: days, hoursTotal: hoursTotal, hours: hours, minutes: minutes, seconds: seconds)
    let daysLessThanOne = formatWhenDaysLessThanOne(isLong: isLong, hasThreeParts: hasThreeParts, days: days, hours: hours, minutes: minutes, seconds: seconds)
    
    return days >= 1 ? daysMoreThanOne : daysLessThanOne
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
