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
    
    private lazy var trackerStore = TrackerStore()
    private lazy var trackerCategoryStore = TrackerCategoryStore()
    private lazy var trackerRecordStore = TrackerRecordStore()
    
    
}
