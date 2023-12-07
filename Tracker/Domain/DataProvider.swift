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
    @Observable
    var category: String = "Важное"
    var color: UIColor = .black
    var selectedCategory: String?
    var selectedSchedule: String?
    let tableViewTitle = [NSLocalizedString("createTracker.button.category", comment: ""),
                          NSLocalizedString("createTracker.button.schedule", comment: "")]
    var trackerName: String?
    var trackerEmoji: String?
    var trackerColor: UIColor?
    var schedule: [Int] = []
    var currentDate: Date?
    var trackerCat: String?
    var title = ""
    var emoji = ""
    var query: String = ""
    var day = 1
    
    private lazy var trackerStore = TrackerStore()
    private lazy var trackerCategoryStore = TrackerCategoryStore()
    private lazy var trackerRecordStore = TrackerRecordStore()
//    var trackerViewController: TrackerViewController
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
        schedule = []
    }
    
    
    var emojies = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱",
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
    ]
    
    var colors: [UIColor] = [
        .colorSection1,
        .colorSection2,
        .colorSection3,
        .colorSection4,
        .colorSection5,
        .colorSection6,
        .colorSection7,
        .colorSection8,
        .colorSection9,
        .colorSection10,
        .colorSection11,
        .colorSection12,
        .colorSection13,
        .colorSection14,
        .colorSection15,
        .colorSection16,
        .colorSection17,
        .colorSection18,
    ]
    
    private func clean() {
        schedule = []
        trackerColor = nil
        trackerEmoji = ""
        trackerName = ""
    }
    
    
    private let shortDaysArray = [NSLocalizedString("mo", comment: ""),
                                  NSLocalizedString("tu", comment: ""),
                                  NSLocalizedString("we", comment: ""),
                                  NSLocalizedString("th", comment: ""),
                                  NSLocalizedString("fr", comment: ""),
                                  NSLocalizedString("sa", comment: ""),
                                  NSLocalizedString("su", comment: "")]
    
    func updateCategories() {
        let category = trackerStore.fetchTracker()
        delegate?.updateCategories(category)
    }
    
    func setCategory(category: String) {
        self.category = category
    }
    
    func scheduleContains(_ day: Int) -> Bool {
        schedule.contains(day)
    }
    
    func addDay(day: Int){
        schedule.append(day)
    }
    
    func removeDay(day: Int) {
        schedule.removeAll { $0 == day }
    }
    
    func getFormattedSchedule() -> String? {
        guard !schedule.isEmpty else {
            return nil
        }
        
        
        let days = schedule.map { shortDaysArray[$0 - 1] }
        return days.joined(separator: ", ")
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
                                 schedule: schedule,
                                 pinned: false)
        trackerStore.addTracker(model: newTracker)
        delegate?.addTrackers()
        clearTracker()
    }
    
    private func clearTracker() {
        trackerName = nil
        trackerColor = nil
        trackerEmoji = nil
        schedule = []
    }
    
    func updateTracker(model: Tracker) {
        guard let trackerColor = trackerColor,
              let trackerName = trackerName,
              let trackerEmoji = trackerEmoji
        else { return }
        
        trackerStore.deleteTacker(model: model)
        let tracker = Tracker(id: model.id,
                              name: trackerName,
                              color: trackerColor,
                              emoji: trackerEmoji,
                              schedule: schedule,
                              pinned: false)
        trackerStore.addTracker(model: tracker)
        delegate?.addTrackers()
        clean()
    }
    
    func updateButtonEnabled() -> Bool {
        guard let trackerColor = trackerColor,
              let trackerName = trackerName,
              let trackerEmoji = trackerEmoji
        else { return false }
        
        if !trackerEmoji.isEmpty && trackerColor != nil && !trackerName.isEmpty {
            return true
        } else {
            return false
        }
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
    
    func deleteCategory(at header: String) {
        trackerCategoryStore.deleteCategory(at: header)
    }
    
    func deleteTracker(model: Tracker) {
        trackerStore.deleteTacker(model: model)
    }
    
    func pinTracker(model: Tracker) {
        trackerStore.pinTacker(model: model)
    }
    
    
    //MARK: - TreckerRecord
    func updateRecords() {
        let newRecords = trackerRecordStore.getRecords()
        delegate?.updateRecords(newRecords)
    }
    
    func addRecord(_ record: TrackerRecord) {
        trackerRecordStore.addTrackerRecord(record)
        let currentCount = UserDefaults.standard.integer(forKey: "completedTrackers")
        let newCount = currentCount + 1
        UserDefaults.standard.set(newCount, forKey: "completedTrackers")
    }
    
    func deleteRecord(_ record: TrackerRecord) {
        trackerRecordStore.deleteTrackerRecord(record)
        let currentCount = UserDefaults.standard.integer(forKey: "completedTrackers")
        let newCount = max(currentCount - 1, 0)
        UserDefaults.standard.set(newCount, forKey: "completedTrackers")
    }
    
    func getCompletedTrackers() -> Int {
        let completedTrackers = UserDefaults.standard.integer(forKey: "completedTrackers")
        return completedTrackers
    }
    
    
    
    func showNewTrackersAfterChanges(_ totalTrackers: [TrackerCategory]) -> [TrackerCategory] {
        guard let date = currentDate else { return [] }
        
                var newArray: [TrackerCategory] = []
                let calendar = Calendar.current
        
                for category in totalTrackers {
                    var newCategory = TrackerCategory(header: category.header, trackerArray: [])
        
        
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
