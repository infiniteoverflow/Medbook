//
//  LandingViewModel.swift
//  Medbook
//
//  Created by Aswin Gopinathan on 14/04/25.
//

import Foundation
import SwiftUI
import SwiftData

final class LandingViewModel: ObservableObject {
    let modelContext: ModelContext
    let router: LandingRouter
    
    init(modelContext: ModelContext, router: LandingRouter) {
        self.modelContext = modelContext
        self.router = router
    }
    
    func navigateToLogin() {
        router.navigateToLogin()
    }
    
    func navigateToSignUp() {
        router.navigateToSignUp()
    }
}
