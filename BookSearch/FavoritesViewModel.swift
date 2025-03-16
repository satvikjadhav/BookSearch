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
    }

    func fetchFavorites() {
        favoriteBooks = coreDataService.fetchFavoriteBooks()
    }

    func removeFavorite(book: Book) {
        coreDataService.removeFavoriteBook(withId: book.id)
        fetchFavorites()
    }
}
