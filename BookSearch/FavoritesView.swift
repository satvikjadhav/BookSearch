//
//  FavoritesView.swift
//  BookSearch
//
//  Created by Satvik  Jadhav on 3/16/25.
//

import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel: FavoritesViewModel

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.favoriteBooks) { book in
                    BookRow(
                        book: book,
                        isFavorite: true,
                        toggleFavorite: { viewModel.removeFavorite(book: book) }
                    )
                }
                .onDelete(perform: deleteFavorites)
            }
            .navigationTitle("Favorite Books")
        }
    }

    private func deleteFavorites(at offsets: IndexSet) {
        offsets.forEach { index in
            let book = viewModel.favoriteBooks[index]
            viewModel.removeFavorite(book: book)
        }
    }
}
