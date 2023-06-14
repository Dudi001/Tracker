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
    var completedTrackers: Set<TrackerRecord> = []
    
    lazy var categories: [TrackerCategory] = [
        TrackerCategory(name: "Заголовок1", trackerArray: testTrakers),
        TrackerCategory(name: "Заголовок2", trackerArray: secondTrackers)
    ]
    
    
    var visibleCategories = [TrackerCategory]()
    
    
    private lazy var testTrakers: [Tracker] = [
        Tracker(id: UUID(), name: "Тест 1", color: .colorSelection1, emoji: "🐕", schedule:  []),
            Tracker(id: UUID(), name: "Попрыгать ", color: .colorSelection2, emoji: "😇", schedule: []),
            Tracker(id: UUID(), name: "Сделать сальтуху", color: .colorSelection3, emoji: "🍒", schedule: []),


        ]

    private lazy var secondTrackers: [Tracker] = [
        Tracker(id: UUID(), name: "Накоримить уток", color: .colorSelection7, emoji: "🐤", schedule: []),
        Tracker(id: UUID(), name: "Найти жирафа", color: .colorSelection5, emoji: "🦒", schedule: []),
        Tracker(id: UUID(), name: "Накоримить уток", color: .colorSelection8, emoji: "🐤", schedule: []),
        Tracker(id: UUID(), name: "Найти жирафа", color: .colorSelection9, emoji: "🦒", schedule: []),
    ]
    
    var selectedCategory: String?
    var selectedSchedule: String?
    
    var trackerName: String?
    var trackerEmoji: String?
    var trackerColor: UIColor?
    var schedule: [Int]?
    
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
}
