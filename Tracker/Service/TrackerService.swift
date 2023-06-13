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
        Tracker(id: UUID(), name: "тест2", color: .colorSelection4, emoji: "🐤", schedule: []),
        Tracker(id: UUID(), name: "тест3333", color: .colorSelection6, emoji: "🦒", schedule: []),
        Tracker(id: UUID(), name: "Накоримить уток", color: .colorSelection7, emoji: "🐤", schedule: []),
        Tracker(id: UUID(), name: "Найти жирафа", color: .colorSelection5, emoji: "🦒", schedule: []),
        Tracker(id: UUID(), name: "Накоримить уток", color: .colorSelection8, emoji: "🐤", schedule: []),
        Tracker(id: UUID(), name: "Найти жирафа", color: .colorSelection9, emoji: "🦒", schedule: []),
    ]
}
