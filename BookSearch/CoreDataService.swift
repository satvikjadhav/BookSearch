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
    
    func saveBookAsFavorite(_ book: Book) {
        let context = persistentContainer.viewContext
        // Avoid duplicates
        if isBookFavorite(withId: book.id) { return }
        
        let bookEntity = BookEntity(context: context)
        bookEntity.id = book.id
        bookEntity.title = book.title
        bookEntity.authors = book.authors as NSArray? // Transformable attribute
        bookEntity.publishers = book.publishers as NSArray?
        if let coverId = book.coverId {
            bookEntity.coverId = Int64(coverId)
        } // Optional Int64
        
        do {
            try context.save()
        } catch {
            print("Failed to save favorite book: \(error)")
        }
    }
    
    func removeFavoriteBook(withId id: String) {
        let context = persistentContainer.viewContext
        if let bookEntity = fetchBookEntity(withId: id) {
            context.delete(bookEntity)
            do {
                try context.save()
            } catch {
                print("Failed to remove favorite book: \(error)")
            }
        }
    }
    
    func fetchFavoriteBooks() -> [Book] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        do {
            let bookEntities = try context.fetch(fetchRequest)
            return bookEntities.map { entity in
                Book(
                    id: entity.id ?? "",
                    title: entity.title ?? "",
                    authors: entity.authors as? [String],
                    publishers: entity.publishers as? [String],
                    coverId: Int(entity.coverId)
                )
            }
        } catch {
            print("Failed to fetch favorite books: \(error)")
            return []
        }
    }
    
}
