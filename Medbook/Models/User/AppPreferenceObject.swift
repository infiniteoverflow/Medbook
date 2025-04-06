//
//  AppPreferenceObject.swift
//  Medbook
//
//  Created by Aswin Gopinathan on 06/04/25.
//

import SwiftData

@Model
final class AppPreferenceObject {
    @Attribute(.unique)
    var encodedCredential: String
    
    init(encodedCredential: String) {
        self.encodedCredential = encodedCredential
    }
}
