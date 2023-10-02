//
//  DataProvider.swift
//  Tracker
//
//  Created by Мурад Манапов on 21.09.2023.
//

import UIKit

protocol DataProviderDelegate: AnyObject {
    func addTrackers()
    func updateCategories(_ newCategory: [TrackerCategory])
    func updateRecords(_ newRecord: Set<TrackerRecord>)
}

final class DataProvider {
    var category: String = "Важное"
    var color: UIColor = .gray
    static let shared = DataProvider()
//    private var schedule: [Int] = []
//    var currentDate: Date?
    var selectedCategory: String?
    var selectedSchedule: String?
    let tableViewTitle = ["Категория", "Расписание"]
    
    var trackerName: String?
    var trackerEmoji: String?
    var trackerColor: UIColor?
    var schedule: [Int]?
    var currentDate: Date?
    
    private lazy var trackerStore = TrackerStore()
    private lazy var trackerCategoryStore = TrackerCategoryStore()
    private lazy var trackerRecordStore = TrackerRecordStore()
    
    var categories: [TrackerCategory] = []
    var visibleCategories = [TrackerCategory]()
    var completedTrackers: Set<TrackerRecord> = []
    
    weak var delegate: DataProviderDelegate?
    
    func resetNewTrackerInfo() {
        selectedCategory = nil
        selectedSchedule = nil
        trackerName = nil
        trackerColor = nil
        trackerEmoji = nil
        schedule = nil
    }
    
    
    var emojies = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱",
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
    ]
    
    var colors: [UIColor] = [
        .colorSelection1,
        .colorSelection2,
        .colorSelection3,
        .colorSelection4,
        .colorSelection5,
        .colorSelection6,
        .colorSelection7,
        .colorSelection8,
        .colorSelection9,
        .colorSelection10,
        .colorSelection11,
        .colorSelection12,
        .colorSelection13,
        .colorSelection14,
        .colorSelection15,
        .colorSelection16,
        .colorSelection17,
        .colorSelection18,
    ]
    
    
    private let shortDayArray = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
    
    func updateCategories() {
        let category = trackerStore.fetchTracker()
        delegate?.updateCategories(category)
    }
    
    func setCategory(category: String) {
        self.category = category
    }
    
    func addDay(day: Int){
        schedule?.append(day)
    }
    
    func removeDay(day: Int) {
        schedule?.removeAll { $0 == day }
    }
    
    func scheduleContains(_ day: Int) -> Bool {
        
        ((schedule?.contains(day)) != nil)
    }
 
//    func createTracker() {
//        let tracker = Tracker(id: UUID(),
//                              name: "",
//                              color: self.color,
//                              emoji: "",
//                              schedule: schedule)
//        trackerStore.addTracker(model: tracker)
//        delegate?.addTrackers()
////        clean()
//    }
    
    func createTracker2() {
        guard let trackerColor = trackerColor,
              let trackerName = trackerName,
              let trackerEmoji = trackerEmoji
        else { return }

//        let categories = trackerStorage.categories
        let newTracker = Tracker(id: UUID(),
                                 name: trackerName,
                                 color: trackerColor,
                                 emoji: trackerEmoji,
                                 schedule: schedule ?? [1, 2, 3, 4, 5, 6, 7])
        trackerStore.addTracker(model: newTracker)
        delegate?.addTrackers()
        
//        var newCategory: [TrackerCategory] = []
//
//        categories.forEach { category in
//            if trackerStorage.selectedCategory == category.name {
//                var newTrackers = category.trackerArray
//                newTrackers.append(newTracker)
//                newCategory.append(TrackerCategory(name: category.name, trackerArray: newTrackers))
//            } else {
//                newCategory.append(category)
//            }
//
//        }
//        return newCategory
    }
    
    func addCategory(header: String) {
        trackerCategoryStore.addCategory(header: header)
    }
    
    func getTrackers() -> [TrackerCategory] {
        trackerStore.fetchTracker()
    }
    
    func getCategories() -> [String] {
        trackerCategoryStore.getCategories()
    }
    
    func setMainCategory() {
        trackerCategoryStore.setMainCategory()
    }
    
//    func updateButtonEnabled() -> Bool {
//        if !emoji.isEmpty && color != .black && !title.isEmpty {
//            return true
//        } else {
//            return false
//        }
//    }
    
    //MARK: - TreckerRecord
    
    func updateRecords() {
        let newRecords = trackerRecordStore.getRecords()
        delegate?.updateRecords(newRecords)
    }
    
    func addRecord(_ record: TrackerRecord) {
        trackerRecordStore.addTrackerRecord(record)
    }
    
    func deleteRecord(_ record: TrackerRecord) {
        trackerRecordStore.deleteTrackerRecord(record)
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
    
//    func getFormattedSchedule() -> String? {
//        guard !schedule.isEmpty else {
//            return nil
//        }
//
//        let days = schedule.map { shortDayArray[$0 - 1] }
//        return days.joined(separator: ", ")
//    }
    
//    private func clean() {
//        schedule = []
//        color = .black
//        emoji = ""
//        title = ""
//    }
    
}
