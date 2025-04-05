//
//  SwiftDataHelper.swift
//  Medbook
//
//  Created by Aswin Gopinathan on 05/04/25.
//

import SwiftData
import SwiftUI

struct SwiftDataHelper {
    private init() {
        //Empty Init
    }
    
    static let shared = SwiftDataHelper()
    
    @Environment(\.modelContext) var modelContext
    
    func storeData(_ data: any PersistentModel) {
        modelContext.insert(data)
    }
}
