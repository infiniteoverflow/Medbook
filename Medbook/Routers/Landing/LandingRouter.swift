//
//  LandingRouter.swift
//  Medbook
//
//  Created by Aswin Gopinathan on 12/04/25.
//

import SwiftUI
import SwiftData
import Foundation

//Decides between landing on the LandingPage or HomePage based on user state
final class LandingRouter {
    let navigationCoordinator: NavigationCoordinatorProtocol
    let modelContext: ModelContext
    let uuid = UUID()
    
    init(navigationCoordinator: NavigationCoordinatorProtocol,
         modelContext: ModelContext) {
        self.navigationCoordinator = navigationCoordinator
        self.modelContext = modelContext
    }
}

extension LandingRouter {
    func navigateToLogin() {
        let loginRouter = LoginViewRouter(modelContext: modelContext,
                                          rootCoordinator: navigationCoordinator)
        navigationCoordinator.push(router: loginRouter)
    }
    
    func navigateToSignUp() {
        let signupRouter = SignupRouter(modelContext: modelContext,
                                        navigationCoordinator: navigationCoordinator)
        navigationCoordinator.push(router: signupRouter)
    }
}

extension LandingRouter: RoutableView {
    func makeView() -> AnyView {
        let landingVM = LandingViewModel(modelContext: modelContext,
                                         router: self)
        let landingPage = LandingView(vm: landingVM)
        return AnyView(landingPage)
    }
}

extension LandingRouter {
    static func == (_ lhs: LandingRouter, _ rhs: LandingRouter) -> Bool {
        lhs.uuid == rhs.uuid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.uuid)
    }
}
