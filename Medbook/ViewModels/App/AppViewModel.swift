//
//  AppViewModel.swift
//  Medbook
//
//  Created by Aswin Gopinathan on 06/04/25.
//

import SwiftUI
import SwiftData

enum AppUserState {
    case loading
    case loggedIn
    case newUser
}

final class AppViewModel: ObservableObject, AppViewModelProtocol {
    var appPreferenceObject: AppPreferenceObject?
    @Published var userState: AppUserState = .loading
    let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        isUserLoggedIn()
    }
    
    func isUserLoggedIn() {
        let swiftDataHelper = SwiftDataHelper(modelContext: modelContext)
        let appPreferenceData: [AppPreferenceObject]? = swiftDataHelper.fetchData()
        appPreferenceObject = appPreferenceData?.first
        
        if let appPreferenceData,
           !appPreferenceData.isEmpty {
            userState = .loggedIn
            return
        }
        
        userState = .newUser
    }
}
