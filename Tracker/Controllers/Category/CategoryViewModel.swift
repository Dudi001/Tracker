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
    
    var selectIndexPath: IndexPath?
    
    init() {
        self.categoryArray = dataProvider.getCategories()
    }
    
    
    func getCategory(at index: Int) -> String {
        categoryArray[index]
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        selectIndexPath = indexPath
        if !categoryArray.isEmpty {
            let category = categoryArray[indexPath.row]
            DataProvider.shared.setCategory(category: category)
        }
    }
    
    func cellIsSelected(at indexPath: IndexPath) -> Bool {
        selectIndexPath == indexPath
    }
    
    func clearSelection() {
        selectIndexPath = nil
    }
    
    func updateData() {
        categoryArray = DataProvider.shared.getCategories()
    }
}
