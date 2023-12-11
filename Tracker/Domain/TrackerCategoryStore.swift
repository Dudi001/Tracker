//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Мурад Манапов on 21.09.2023.
//

import UIKit
import CoreData

final class TrackerCategoryStore: NSObject {
    private lazy var appDelegate = {
        UIApplication.shared.delegate as! AppDelegate
    }()
    private lazy var context = {
        appDelegate.persistentContainer.viewContext
    }()
    
    private lazy var fetchedResultController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerCategoryCoreData.header, ascending: true)]
        let fetchController = NSFetchedResultsController(fetchRequest: request,
                                                         managedObjectContext: context,
                                                         sectionNameKeyPath: nil,
                                                         cacheName: nil)
        fetchController.delegate = self
        
        do {
            try fetchController.performFetch()
        } catch  {
            assertionFailure(error.localizedDescription)
        }
        return fetchController
    }()
    
    func numberOfCategories() -> Int {
        fetchedResultController.fetchedObjects?.count ?? 0
    }
    
    func addCategory(header: String) {
        if !checkCategoryInCoreData(header: header) {
            let category = TrackerCategoryCoreData(context: context)
            category.header = header
            appDelegate.saveContext()
        }
    }
    
    func checkCategoryInCoreData(header: String) -> Bool {
        guard let categories = fetchedResultController.fetchedObjects else { return false }
        
        return categories.contains(where: { $0.header == header })
    }
    
    func setMainCategory() {
        if !checkCategoryInCoreData(header: "Важное") {
            let category = TrackerCategoryCoreData(context: context)
            category.header = "Важное"
            appDelegate.saveContext()
        }
    }
    
    func deleteCategory(at header: String) {
        guard let categories = fetchedResultController.fetchedObjects else { return }
        if let categoryToDelete = categories.first(where: { $0.header == header }) {
            context.delete(categoryToDelete)
            appDelegate.saveContext()
        }
    }
    
    func getCategories() -> [String] {
        guard let categories = fetchedResultController.fetchedObjects else { return [] }
        let categoriesArray: [String] = categories.compactMap { $0.header }
        return categoriesArray
    }
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        do {
            try fetchedResultController.performFetch()
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }
}

