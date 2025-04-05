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
    
    init(encodedCredential: String) {
        self.encodedCredential = encodedCredential
    }
}
