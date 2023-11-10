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
    
    func didSelectRow(at indexPath: IndexPath) {
        selectedIndexPath = indexPath
        if !categoryArray.isEmpty {
            let category = categoryArray[indexPath.row]
            DataProvider.shared.setCategory(category: category)
        }
    }
    
    func test() -> Bool {
        if !categoryArray.isEmpty {
            return true
        }
        return false
    }
    
    func cellIsSelected(at indexPath: IndexPath) -> Bool {
        selectedIndexPath == indexPath
    }
    
    func clearSelection() {
        selectedIndexPath = nil
    }
    
    func updateData() {
        categoryArray = DataProvider.shared.getCategories()
    }
}
