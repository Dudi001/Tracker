//
//  NewTrackerViewModel.swift
//  Tracker
//
//  Created by Мурад Манапов on 08.11.2023.
//

import Foundation


final class CreateCategoryViewModel {
    
    @Observable
    private(set) var isCreateButtonEnabled: Bool = false
    
    weak var delegate: NewTrackerViewModelDelegate?
    
    func didEnter(header: String?) {
        guard let header else { return }
        isCreateButtonEnabled = header != ""
    }
    
    func createButtonPressed(category: String) {
        DataProvider.shared.addCategory(header: category)
        delegate?.updateCategory()
    }
}
