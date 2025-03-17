//
//  SearchViewModel.swift
//  BookSearch
//
//  Created by Satvik  Jadhav on 3/16/25.
//

import SwiftUI

@MainActor
class SearchViewModel: ObservableObject {
    @Published var query: String = ""
    @Published var books: [Book] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    private let apiService = BookAPIService()
    private let coreDataService: CoreDataService

    init(coreDataService: CoreDataService) {
        self.coreDataService = coreDataService
        // Listen for favorite updates
        NotificationCenter.default.addObserver(
            forName: .didUpdateFavorites,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.objectWillChange.send() // Trigger UI refresh
        }
    }

    func search() async {
        guard !query.isEmpty else {
            books = []
            return
        }
        isLoading = true
        errorMessage = nil
        do {
            books = try await apiService.fetchBooks(query: query)
        } catch {
            errorMessage = "Failed to fetch books: \(error.localizedDescription)"
        }
        isLoading = false
    }

    func isFavorite(book: Book) -> Bool {
        coreDataService.isBookFavorite(withId: book.id)
    }

    func toggleFavorite(for book: Book) {
        if coreDataService.isBookFavorite(withId: book.id) {
            coreDataService.removeFavoriteBook(withId: book.id)
        } else {
            coreDataService.saveBookAsFavorite(book)
        }
        objectWillChange.send() // Manually trigger UI update
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
