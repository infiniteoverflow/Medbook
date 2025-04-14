//
//  LoginViewRouter.swift
//  Medbook
//
//  Created by Aswin Gopinathan on 14/04/25.
//

import Foundation
import SwiftUI
import SwiftData

final class LoginViewRouter: RoutableView {
    let uuid = UUID()
    let modelContext: ModelContext
    let rootCoordinator: NavigationCoordinatorProtocol
    
    init(modelContext: ModelContext,
         rootCoordinator: NavigationCoordinatorProtocol) {
        self.modelContext = modelContext
        self.rootCoordinator = rootCoordinator
    }

    func makeView() -> AnyView {
        let loginVM = LoginViewModel(router: self,
                                     modelContext: modelContext)
        return AnyView(LoginView(vm: loginVM))
    }
}

extension LoginViewRouter {
    func navigateToHome() {
        let homeRouter = HomePageRouter(navigationCoordinator: rootCoordinator,
                                        modelContext: modelContext)
        rootCoordinator.push(router: homeRouter)
    }
    
    func navigateToSignUp() {
        let signupRouter = SignupRouter(modelContext: modelContext,
                                        navigationCoordinator: rootCoordinator)
        rootCoordinator.pushClearingAll(router: signupRouter)
    }
}

extension LoginViewRouter {
    static func == (lhs: LoginViewRouter, rhs: LoginViewRouter) -> Bool {
        lhs.uuid == rhs.uuid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
