//
//  Item.swift
//  Medbook
//
//  Created by Aswin Gopinathan on 05/04/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
