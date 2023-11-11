//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Мурад Манапов on 03.11.2023.
//

import Foundation


final class CategoryViewModel {
    let dataProvider = DataProvider.shared
    
    @Observable
    var categoryArray: [String] = []
    
    var selectedIndexPath: IndexPath?
    
    var categoriesCount: Int {
        categoryArray.count
    }
    
    init() {
        self.categoryArray = dataProvider.getCategories()
    }
    
    func getCategory(at index: Int) -> String {
        categoryArray[index]
    }
    
    func clearSelection() {
        selectedIndexPath = nil
    }
    
    func updateData() {
        categoryArray = DataProvider.shared.getCategories()
    }
}
