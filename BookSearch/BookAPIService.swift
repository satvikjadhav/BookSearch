//
//  BookAPIService.swift
//  BookSearch
//
//  Created by Satvik  Jadhav on 3/16/25.
//

import SwiftUI

class BookAPIService {
    func fetchBooks(query: String) async throws -> [Book] {
        // Construct URL with query, ensuring proper encoding
        let urlString = "https://openlibrary.org/search.json?q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        // Fetch data asynchronously
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        let response = try decoder.decode(SearchResponse.self, from: data)
        return response.docs
    }
}

// Struct to decode the API's JSON response
struct SearchResponse: Codable {
    let docs: [Book]
}
