//
//  BookListingData.swift
//  Medbook
//
//  Created by Aswin Gopinathan on 06/04/25.
//

import Foundation

struct BookListingData: Codable {
    let docs: [BookData]?
}

struct BookData: Codable, Hashable, Identifiable {
    let id = UUID()
    let authorName: [String]?
    let coverI: Int?
    let title: String?
    let firstPublishYear: Int?
    let lendingIdentifier: String?
    var isBookmarked: Bool?
    
    enum CodingKeys: String, CodingKey {
        case authorName = "author_name"
        case coverI = "cover_i"
        case firstPublishYear = "first_publish_year"
        case title
        case lendingIdentifier = "lending_identifier_s"
    }
    
    init(authorName: [String]?,
         coverI: Int?,
         title: String?,
         firstPublishYear: Int?,
         lendingIdentifier: String?,
         isBookmarked: Bool?) {
        self.authorName = authorName
        self.coverI = coverI
        self.title = title
        self.firstPublishYear = firstPublishYear
        self.lendingIdentifier = lendingIdentifier
        self.isBookmarked = isBookmarked
    }
    
    init(from book: BookObject) {
        self.init(authorName: book.authorName,
                  coverI: book.coverI,
                  title: book.title,
                  firstPublishYear: book.firstPublishYear,
                  lendingIdentifier: book.identifier,
                  isBookmarked: book.isBookmarked)
    }
}
