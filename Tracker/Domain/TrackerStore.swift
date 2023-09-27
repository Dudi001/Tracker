//
//  TrackerStore.swift
//  Tracker
//
//  Created by Мурад Манапов on 21.09.2023.
//

import UIKit
import CoreData

protocol TrackerStorageProtocol: AnyObject {
    func addTracker(model: Tracker)
    func fetchTracker() -> [TrackerCategory]
}

final class TrackerStore: NSObject, TrackerStorageProtocol{
//    private let colorMarshaling =
    private let dataProvider = DataProvider.shared
    
    private var insertIndex: IndexSet?
    private var deletIndex: IndexSet?
    private var section: Int?
    
    private lazy var appDelegate = {
        UIApplication.shared.delegate as! AppDelegate
    }()
    
    private lazy var context = {
        appDelegate.persistentContainer.viewContext
    }()
    
    private lazy var fetchResultController: NSFetchedResultsController<TrackerCoreData> = {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerCoreData.category?.header, ascending: true)]
        let fetchController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: "category.header",
            cacheName: nil)
        
        fetchController.delegate = self
        
        do {
            try fetchController.performFetch()
        } catch  {
            print(error.localizedDescription)
        }
        return fetchController
    }()
    
    
    
    func addTracker(model: Tracker) {
        let category = dataProvider.category
        let tracker = TrackerCoreData(context: context)
//        let color = colorMarshaling.hexString(from: model.color)
        
        let categoryFetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
            categoryFetchRequest.predicate = NSPredicate(format: "header == %@", category)
            let categoryResults = try? context.fetch(categoryFetchRequest)
            let categoryCoreData = categoryResults?.first ?? TrackerCategoryCoreData(context: context)
            categoryCoreData.header = category
        
        tracker.id = model.id
//        tracker.color = color
        tracker.emoji = model.emoji
        tracker.name = model.name
        tracker.schedule = model.schedule
        tracker.category = categoryCoreData
        
        appDelegate.saveContext()
    }
    
    func fetchTracker() -> [TrackerCategory] {
        guard let sections = fetchResultController.sections else {return [] }
        
        var trackerCategoryArray: [TrackerCategory] = []
        
        for section in sections {
            guard let object = section.objects as? [TrackerCoreData] else { continue }
            
            var trackers: [Tracker] = []
            
            
            for tracker in object {
                let color = UIColor() //colorMarshaling.color(from: tracker.color ?? "")
                let newTracker = Tracker(
                    id: tracker.id ?? UUID(),
                    name: tracker.name ?? "",
                    color: color,
                    emoji: tracker.emoji ?? "",
                    schedule: tracker.schedule ?? [])
                
                trackers.append(newTracker)
            }
            
            let trackerCategory = TrackerCategory(name: section.name, trackerArray: trackers)
            trackerCategoryArray.append(trackerCategory)
        }
        return trackerCategoryArray
        
        
        
    }
    
}

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertIndex = IndexSet()
        deletIndex = IndexSet()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        try? fetchResultController.performFetch()
//        dataProvider.updateCategories()
    }
}
