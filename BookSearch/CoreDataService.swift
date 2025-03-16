//
//  CoreDataService.swift
//  BookSearch
//
//  Created by Satvik  Jadhav on 3/16/25.
//

import CoreData

class CoreDataService {
    let persistentContainer: NSPersistentContainer
    
    init() {
        persistentContainer = NSPersistentContainer(name: "BookAppModel")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data store failed to load: \(error)")
            }
        }
    }
    
    private func fetchBookEntity(withId id: String) -> BookEntity? {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.fetchLimit = 1
        do {
            return try context.fetch(fetchRequest).first
        } catch {
            print("Failed to fetch book entity: \(error)")
            return nil
        }
    }
    
    func isBookFavorite(withId id: String) -> Bool {
        return fetchBookEntity(withId: id) != nil
    }
    
    
}
