//
//  UserObject.swift
//  Medbook
//
//  Created by Aswin Gopinathan on 05/04/25.
//

import SwiftData

@Model
final class UserObject {
    @Attribute(.unique)
    var encodedCredential: String
    
    @Relationship(deleteRule: .cascade)
    var bookmarks: [BookObject] = []
    
    init(encodedCredential: String,
         bookmarks: [BookObject] = []) {
        self.encodedCredential = encodedCredential
        self.bookmarks = bookmarks
    }
}
