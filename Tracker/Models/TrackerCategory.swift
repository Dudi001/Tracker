//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Мурад Манапов on 03.06.2023.
//

import UIKit

struct TrackerCategory {
    let header: String
    var trackerArray: [Tracker]
    
    init(header: String, trackerArray: [Tracker]) {
        self.header = header
        self.trackerArray = trackerArray
    }
}
