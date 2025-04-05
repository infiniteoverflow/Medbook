//
//  MedbookApp.swift
//  Medbook
//
//  Created by Aswin Gopinathan on 05/04/25.
//

import SwiftUI
import SwiftData

@main
struct MedbookApp: App {
    @StateObject private var navigationManager = NavigationManager()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navigationManager.navigationPath) {
                LandingView()
                    .navigationDestination(for: NavigationScreen.self) { screen in
                        switch screen {
                        case .signup:
                            SignupView(vm: SignupViewModel())
                        case .login:
                            LoginView(vm: LoginViewModel(navigationManager: navigationManager))
                        case .home:
                            Text("Home")
                        case .bookmarks:
                            Text("Bookmarks")
                        }
                    }
            }
        }
        .environmentObject(navigationManager)
    }
}
