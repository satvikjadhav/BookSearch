//
//  ContentView.swift
//  BookSearch
//
//  Created by Satvik  Jadhav on 3/16/25.
//

import SwiftUI

struct ContentView: View {
    let coreDataService = CoreDataService()
    @StateObject var searchViewModel: SearchViewModel
    @StateObject var favoritesViewModel: FavoritesViewModel

    init() {
        let service = coreDataService
        _searchViewModel = StateObject(wrappedValue: SearchViewModel(coreDataService: service))
        _favoritesViewModel = StateObject(wrappedValue: FavoritesViewModel(coreDataService: service))
    }

    var body: some View {
        TabView {
            SearchView(viewModel: searchViewModel)
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            FavoritesView(viewModel: favoritesViewModel)
                .tabItem {
                    Label("Favorites", systemImage: "heart")
                }
        }
    }
}

#Preview {
    ContentView()
}
