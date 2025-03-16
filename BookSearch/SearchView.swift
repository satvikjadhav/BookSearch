//
//  SearchView.swift
//  BookSearch
//
//  Created by Satvik  Jadhav on 3/16/25.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var viewModel: SearchViewModel

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.books) { book in
                    BookRow(
                        book: book,
                        isFavorite: viewModel.isFavorite(book: book),
                        toggleFavorite: { viewModel.toggleFavorite(for: book) }
                    )
                }
            }
            .navigationTitle("Search Books")
            .searchable(text: $viewModel.query, prompt: "Search for books")
            .onSubmit(of: .search) {
                Task { await viewModel.search() }
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView("Searching...")
                }
            }
            .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK") { viewModel.errorMessage = nil }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
    }
}
