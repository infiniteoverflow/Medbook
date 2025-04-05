//
//  CountryObject.swift
//  Medbook
//
//  Created by Aswin Gopinathan on 05/04/25.
//

import Foundation
import SwiftData

@Model
final class CountryObject {
    @Attribute(.unique)
    var countryCode: String
    var country: String?
    var region: String?
    
    init(countryCode: String,
         country: String? = nil,
         region: String? = nil) {
        self.countryCode = countryCode
        self.country = country
        self.region = region
    }
    
    convenience init(countryCode: String,
                     item: Country) {
        self.init(countryCode: countryCode,
                  country: item.country ?? "",
                  region: item.region ?? "")
    }
}
