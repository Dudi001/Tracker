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
        case "Понедельник":
            return 0
        case "Вторник":
            return 1
        case "Среда":
            return 2
        case "Четверг":
            return 3
        case "Пятница":
            return 4
        case "Суббота":
            return 5
        case "Воскресенье":
            return 6
        default:
            return 7
        }
    }
    
    func changeDayToShortName(day: Int) -> String {
        switch day {
        case 1:
            return "Вс"
        case 2:
            return "Пн"
        case 3:
            return "Вт"
        case 4:
            return "Ср"
        case 5:
            return "Чт"
        case 6:
            return "Пт"
        case 7:
            return "Сб"
        default:
            return ""
        }
    }
}
