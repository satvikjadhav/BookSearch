//
//  FavoritesViewModel.swift
//  BookSearch
//
//  Created by Satvik  Jadhav on 3/16/25.
//

import SwiftUI

@MainActor
class FavoritesViewModel: ObservableObject {
    @Published var favoriteBooks: [Book] = []

    private let coreDataService: CoreDataService

    init(coreDataService: CoreDataService) {
        self.coreDataService = coreDataService
        fetchFavorites()
        // Listen for favorite updates
        NotificationCenter.default.addObserver(
            forName: .didUpdateFavorites,
            object: nil,
            queue: .main  // This already helps but isn't enough
        ) { [weak self] _ in
            Task { @MainActor in
                self?.fetchFavorites()
            }
        }
    }

    func fetchFavorites() {
        favoriteBooks = coreDataService.fetchFavoriteBooks()
    }

    func removeFavorite(book: Book) {
        coreDataService.removeFavoriteBook(withId: book.id)
        fetchFavorites() // Already triggers notification, but keep for clarity
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
