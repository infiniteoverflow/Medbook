//
//  BookObject.swift
//  Medbook
//
//  Created by Aswin Gopinathan on 06/04/25.
//

import SwiftData
import Foundation

@Model
final class BookObject {
    var authorName: [String]
    var coverI: Int
    @Attribute(.unique)
    var identifier: String
    var title: String
    var firstPublishYear: Int
    var isBookmarked: Bool = false
    @Relationship(inverse: \UserObject.bookmarks)
    var user: UserObject?
    
    init(authorName: [String],
         coverI: Int,
         title: String,
         firstPublishYear: Int,
         identifier: String,
         isBookmarked: Bool) {
        self.authorName = authorName
        self.coverI = coverI
        self.title = title
        self.firstPublishYear = firstPublishYear
        self.identifier = identifier
        self.isBookmarked = isBookmarked
    }
    
    convenience init(from book: BookData) {
        self.init(authorName: book.authorName ?? [],
                  coverI: book.coverI ?? 0,
                  title: book.title ?? "",
                  firstPublishYear: book.firstPublishYear ?? 0,
                  identifier: book.lendingIdentifier ?? "",
                  isBookmarked: book.isBookmarked ?? false)
    }
}
