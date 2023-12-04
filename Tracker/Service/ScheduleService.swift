//
//  ScheduleService.swift
//  Tracker
//
//  Created by Мурад Манапов on 14.06.2023.
//

import UIKit

final class ScheduleService {
    
    func arrayToString(array: [Int]) -> String {
        let sortedDays = array.sorted()
        let shortNames = sortedDays.map { changeDayToShortName(day: $0) }
        let finalString = shortNames.joined(separator: ", ")

        return finalString
    }
    
    func addDayToSchedule(day: String) -> Int {
        switch day {
        case NSLocalizedString("monday", comment: ""):
            return 0
        case NSLocalizedString("tuesday", comment: ""):
            return 1
        case NSLocalizedString("wednesday", comment: ""):
            return 2
        case NSLocalizedString("thursday", comment: ""):
            return 3
        case NSLocalizedString("friday", comment: ""):
            return 4
        case NSLocalizedString("saturday", comment: ""):
            return 5
        case NSLocalizedString("sunday", comment: ""):
            return 6
        default:
            return 0
        }
    }
    
    func changeDayToShortName(day: Int) -> String {
        switch day {
        case 6:
            return NSLocalizedString("su", comment: "")
        case 0:
            return NSLocalizedString("mo", comment: "")
        case 1:
            return NSLocalizedString("tu", comment: "")
        case 2:
            return NSLocalizedString("we", comment: "")
        case 3:
            return NSLocalizedString("th", comment: "")
        case 4:
            return NSLocalizedString("fr", comment: "")
        case 5:
            return NSLocalizedString("sa", comment: "")
        default:
            return ""
        }
    }
}
