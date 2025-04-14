//
//  AppViewModel.swift
//  Medbook
//
//  Created by Aswin Gopinathan on 06/04/25.
//

import SwiftUI
import SwiftData

final class AppViewModel: AppViewModelProtocol {
    var appPreferenceObject: AppPreferenceObject?
    var currentUser: UserObject?
    let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func isUserLoggedIn() -> Bool {
        let swiftDataHelper = SwiftDataHelper(modelContext: modelContext)
        let appPreferenceData: [AppPreferenceObject]? = swiftDataHelper.fetchData()
        appPreferenceObject = appPreferenceData?.first

        let users: [UserObject]? = swiftDataHelper.fetchData()
        
        if let appPreferenceObject {
            currentUser = users?.first(where: { obj in
                obj.encodedCredential == appPreferenceObject.encodedCredential
            })
            return true
        }
        
        return false
    }
}
