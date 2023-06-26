//
//  TrackerService.swift
//  Tracker
//
//  Created by Мурад Манапов on 13.06.2023.
//

import UIKit


final class TrackerStorageService {
    static let shared = TrackerStorageService()
    
    private init() {}
    
    var selectedCategory: String?
    var selectedSchedule: String?

    var trackerName: String?
    var trackerEmoji: String?
    var trackerColor: UIColor?
    var schedule: [Int]?
    var currentDate: Date?
    
    var categories: [TrackerCategory] = [
        TrackerCategory(name: "Важное", trackerArray: [Tracker(id: UUID(),
                                                               name: "Учиться делать iOS-приложения",
                                                               color: .colorSelection1,
                                                               emoji: "🐶",
                                                               schedule: [2, 4, 1]),
                                                       Tracker(id: UUID(),
                                                               name: "Получить права",
                                                               color: .colorSelection2,
                                                               emoji: "😻",
                                                               schedule: [2, 5, 6, 7])]),
        TrackerCategory(name: "Уборка", trackerArray: [Tracker(id: UUID(),
                                                               name: "Полить цветы",
                                                               color: .colorSelection3,
                                                               emoji: "🍔",
                                                               schedule: [2, 4, 5, 6, 7]),
                                                       Tracker(id: UUID(),
                                                               name: "Влажная уборка",
                                                               color: .colorSelection4,
                                                               emoji: "😇",
                                                               schedule: [1, 4, 6])])
    ]
    
    
    
    var visibleCategories = [TrackerCategory]()
    var completedTrackers: Set<TrackerRecord> = []
    
    var emojies = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱",
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
    ]
    
    var colors: [UIColor] = [
        .colorSelection1, .colorSelection2, .colorSelection3, .colorSelection4, .colorSelection5, .colorSelection6,
        .colorSelection7, .colorSelection8, .colorSelection9, .colorSelection10, .colorSelection11, .colorSelection12,
        .colorSelection13, .colorSelection14, .colorSelection15, .colorSelection16, .colorSelection17, .colorSelection18,
    ]
    
    let tableViewTitle = ["Категория", "Расписание"]
    
    func resetNewTrackerInfo() {
        selectedCategory = nil
        selectedSchedule = nil
        trackerName = nil
        trackerColor = nil
        trackerEmoji = nil
        schedule = nil
    }
    
    func showNewTrackersAfterChanges(_ totalTrackers: [TrackerCategory]) -> [TrackerCategory] {
        guard let date = currentDate else { return [] }
        
        var newArray: [TrackerCategory] = []
        let calendar = Calendar.current
        
        for category in totalTrackers {
            var newCategory = TrackerCategory(name: category.name, trackerArray: [])
            
            
            for tracker in category.trackerArray {
                let schedule = tracker.schedule
                let trackerDate = calendar.component(.weekday, from: date)
                
                if schedule.contains(trackerDate) {
                    newCategory.trackerArray.append(tracker)
                }
            }
            if !newCategory.trackerArray.isEmpty {
                newArray.append(newCategory)
            }
        }
        return newArray
    }
    
}
