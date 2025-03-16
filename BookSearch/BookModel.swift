//
//  BookModel.swift
//  BookSearch
//
//  Created by Satvik  Jadhav on 3/16/25.
//

import SwiftUI

struct Book: Codable, Identifiable {
    let id: String          // API's "key" field, e.g., "/works/OL1W"
    let title: String
    let authors: [String]?  // API's "author_name"
    let publishers: [String]? // API's "publisher"
    let coverId: Int?       // API's "cover_i" for cover image

    // Computed property for cover image URL
    var coverImageURL: URL? {
        guard let coverId = coverId else { return nil }
        return URL(string: "https://covers.openlibrary.org/b/id/\(coverId)-M.jpg")
    }

    // Custom coding keys to match API field names
    enum CodingKeys: String, CodingKey {
        case id = "key"
        case title
        case authors = "author_name"
        case publishers = "publisher"
        case coverId = "cover_i"
    }
}
