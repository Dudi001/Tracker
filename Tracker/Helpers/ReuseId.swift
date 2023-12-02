//
//  ReuseId.swift
//  Tracker
//
//  Created by Мурад Манапов on 02.12.2023.
//

import Foundation

protocol ReuseIdentifier { }

extension ReuseIdentifier {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
