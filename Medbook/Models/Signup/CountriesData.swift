//
//  CountriesData.swift
//  Medbook
//
//  Created by Aswin Gopinathan on 05/04/25.
//

import Foundation

/// Represents the response received from the countries API
struct CountriesData: Codable {
    /// The status of the API request (e.g., "OK", "Error")
    let status: String?
    /// The HTTP status code of the response (e.g., 200)
    let statusCode: Int?
    /// The version of the API
    let version: String?
    /// The access level of the data (e.g., "public")
    let access: String?
    /// The total number of items available in the API
    let total: Int?
    /// The starting offset of the current data set
    let offset: Int?
    /// The maximum number of items returned in the current request
    let limit: Int?
    /// A dictionary containing country data, where the key is the country code (String)
    /// and the value is a Country object.
    let data: [String: Country]?

    //TODO: Why does String need to come ahead of CodingKey??
    enum CodingKeys: String, CodingKey {
        case status
        case statusCode = "status-code" // Maps the Swift property name to the JSON key "status-code"
        case version
        case access
        case total
        case offset
        case limit
        case data
    }
}

/// Represents information about an individual country
//TODO: Do we need id now?
struct Country: Codable, Hashable, Equatable, Identifiable {
    let id = UUID()
    /// The name of the country
    let country: String?
    /// The region to which the country belongs
    let region: String?
    
    init(object: CountryObject) {
        self.country = object.country
        self.region = object.region
    }
}
