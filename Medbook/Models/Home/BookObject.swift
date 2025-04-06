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
    var title: String
    var firstPublishYear: Int
    
    init(authorName: [String],
         coverI: Int,
         title: String,
         firstPublishYear: Int) {
        self.authorName = authorName
        self.coverI = coverI
        self.title = title
        self.firstPublishYear = firstPublishYear
    }
    
    convenience init(from book: BookData) {
        self.init(authorName: book.authorName ?? [],
                  coverI: book.coverI ?? 0,
                  title: book.title ?? "",
                  firstPublishYear: book.firstPublishYear ?? 0)
    }
}
