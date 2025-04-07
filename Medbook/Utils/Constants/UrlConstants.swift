//
//  UrlConstants.swift
//  Medbook
//
//  Created by Aswin Gopinathan on 05/04/25.
//

struct UrlConstants {
    static let countries = "https://api.first.org/data/v1/countries"
    static let ip = "http://ip-api.com/json"
    
    static func bookListing(title: String, limit: Int, offset: Int) -> String {
        "https://openlibrary.org/search.json?title=\(title)&limit=\(limit)&offset=\(offset)"
    }
    
    static func coverImage(coverI: Int) -> String {
        "https://covers.openlibrary.org/b/id/\(coverI)-M.jpg"
    }
}
