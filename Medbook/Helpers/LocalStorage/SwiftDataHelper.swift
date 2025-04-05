//
//  SwiftDataHelper.swift
//  Medbook
//
//  Created by Aswin Gopinathan on 05/04/25.
//

import SwiftData
import SwiftUI

enum DataSaveResult {
    case success
    case failure
}

struct SwiftDataHelper {
    let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func storeData(_ data: any PersistentModel) {
        modelContext.insert(data)
    }
    
    func fetchData<T: PersistentModel>() -> [T]? {
        do {
            let fetchDescriptor = FetchDescriptor<T>()
            let storedData = try modelContext.fetch(fetchDescriptor)
            return storedData
        } catch {
            print("Error fetching countries from local storage: \(error)")
            return nil
        }
    }
    
    func saveData(completion: (DataSaveResult) -> Void) {
        do {
            try modelContext.save()
            completion(.success)
        } catch {
            print("Error Saving Data")
            completion(.failure)
        }
    }
}
