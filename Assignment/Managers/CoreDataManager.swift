//
//  CoreDataManager 2.swift
//  Assignment
//
//  Created by Harshit ‎ on 6/17/25.
//

import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    lazy var context: NSManagedObjectContext = {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }()
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Save error: \(error)")
            }
        }
    }
    
    // MARK: - DataItem CRUD Operations
    func saveDataItems(_ items: [APIDataItem]) {
        // Clear existing data to avoid duplicates
        let request: NSFetchRequest<NSFetchRequestResult> = DataItem.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try context.execute(deleteRequest)
        } catch {
            print("Error clearing existing data: \(error)")
        }
        
        // Save new items
        for item in items {
            let dataItem = DataItem(context: context)
            dataItem.id = item.id
            dataItem.name = item.name
            dataItem.data = item.dataString
        }
        saveContext()
    }
    
    func fetchDataItems() -> [DataItem] {
        let request: NSFetchRequest<DataItem> = DataItem.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Fetch error: \(error)")
            return []
        }
    }
    
    func updateDataItem(_ item: DataItem, name: String, data: String?) {
        item.name = name
        item.data = data
        saveContext()
    }
    
    func deleteDataItem(_ item: DataItem) {
        context.delete(item)
        saveContext()
    }
}
