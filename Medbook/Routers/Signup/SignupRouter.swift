//
//  SignupRouter.swift
//  Medbook
//
//  Created by Aswin Gopinathan on 14/04/25.
//

import Foundation
import SwiftUI
import SwiftData

final class SignupRouter: RoutableView {
    let uuid = UUID()
    let modelContext: ModelContext
    let navigationCoordinator: NavigationCoordinatorProtocol
    
    init(modelContext: ModelContext,
         navigationCoordinator: NavigationCoordinatorProtocol) {
        self.modelContext = modelContext
        self.navigationCoordinator = navigationCoordinator
    }
    
    func makeView() -> AnyView {
        let signupVM = SignupViewModel(modelContext: modelContext,
                                       router: self)
        return AnyView(SignupView(vm: signupVM))
    }
}

extension SignupRouter {
    func navigateToHome() {
        let homeRouter = HomePageRouter(navigationCoordinator: navigationCoordinator,
                                        modelContext: modelContext)
        navigationCoordinator.push(router: homeRouter)
    }
}

extension SignupRouter {
    static func == (lhs: SignupRouter, rhs: SignupRouter) -> Bool {
        lhs.uuid == rhs.uuid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
