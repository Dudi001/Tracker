//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Мурад Манапов on 28.11.2023.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {
    func testMainVCLight() {
        let vc = TrackerViewController()
        assertSnapshots(matching: vc, as: [.image(traits: .init(userInterfaceStyle: .light))], record: false)
    }
    
    func testMainVCDark() {
        let vc = TrackerViewController()
        assertSnapshots(matching: vc, as: [.image(traits: .init(userInterfaceStyle: .dark))], record: false)
    }
    

}
