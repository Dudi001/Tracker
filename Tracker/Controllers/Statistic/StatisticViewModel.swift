//
//  StatisticViewModel.swift
//  Tracker
//
//  Created by Мурад Манапов on 02.12.2023.
//

import Foundation


final class StatsViewModel {
    func getCompletedTrackers() -> Int {
        DataProvider.shared.getCompletedTrackers()
    }
}
