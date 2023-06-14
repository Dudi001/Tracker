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
            return 2
        case "Вторник":
            return 3
        case "Среда":
            return 4
        case "Четверг":
            return 5
        case "Пятница":
            return 6
        case "Суббота":
            return 7
        case "Воскресенье":
            return 1
        default:
            return 0
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
