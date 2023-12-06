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
    private let colorMarshaling = UIColorMarshalling()
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
        let category = dataProvider.selectedCategory
        let tracker = TrackerCoreData(context: context)
        let color = colorMarshaling.hexString(from: model.color)
        
        let categoryFetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        categoryFetchRequest.predicate = NSPredicate(format: "header == %@", category ?? "Slyapa")
            let categoryResults = try? context.fetch(categoryFetchRequest)

            let categoryCoreData = categoryResults?.first ?? TrackerCategoryCoreData(context: context)
            categoryCoreData.header = category
        
        tracker.id = model.id
        tracker.color = color
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
                let color = colorMarshaling.color(from: tracker.color ?? "")
                let newTracker = Tracker(
                    id: tracker.id ?? UUID(),
                    name: tracker.name ?? "",
                    color: color,
                    emoji: tracker.emoji ?? "",
                    schedule: tracker.schedule ?? [],
                    pinned: tracker.pinned)
                
                trackers.append(newTracker)
            }
            
            let trackerCategory = TrackerCategory(header: section.name, trackerArray: trackers)
            trackerCategoryArray.append(trackerCategory)
        }
//        print(trackerCategoryArray)
        return trackerCategoryArray
    }
    
    func pinTacker(model: Tracker) {
            let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", model.id as CVarArg)
            do {
                let trackers = try context.fetch(fetchRequest)
                if let tracker = trackers.first {
                    tracker.pinned = !model.pinned
                    appDelegate.saveContext()
                }
            } catch {
                print("Error deleting tracker record: \(error.localizedDescription)")
            }
    }
    
    func deleteTacker(model: Tracker) {
            let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", model.id as CVarArg)
            do {
                let trackers = try context.fetch(fetchRequest)
                if let tracker = trackers.first {
                    context.delete(tracker)
                    appDelegate.saveContext()
                }
            } catch {
                print("Error deleting tracker record: \(error.localizedDescription)")
            }
    }
}

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertIndex = IndexSet()
        deletIndex = IndexSet()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        try? fetchResultController.performFetch()
        dataProvider.updateCategories()
    }
}
