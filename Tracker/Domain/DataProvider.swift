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
    
    static let shared = DataProvider()
    var category: String = "Важное"
    var color: UIColor = .gray
    var selectedCategory: String?
    var selectedSchedule: String?
    let tableViewTitle = ["Категория", "Расписание"]
    var trackerName: String?
    var trackerEmoji: String?
    var trackerColor: UIColor?
    var schedule: [Int]?
    var currentDate: Date?
    var trackerCat: String?
    
    private lazy var trackerStore = TrackerStore()
    private lazy var trackerCategoryStore = TrackerCategoryStore()
    private lazy var trackerRecordStore = TrackerRecordStore()
    
    var categories: [TrackerCategory] = []
//        trackerStore.fetchTracker()
//    }
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
    
    func createTracker() {
        guard let trackerColor = trackerColor,
              let trackerName = trackerName,
              let trackerEmoji = trackerEmoji
        else { return }

        let newTracker = Tracker(id: UUID(),
                                 name: trackerName,
                                 color: trackerColor,
                                 emoji: trackerEmoji,
                                 schedule: schedule ?? [1, 2, 3, 4, 5, 6, 7])
        trackerStore.addTracker(model: newTracker)
        delegate?.addTrackers()
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
}
