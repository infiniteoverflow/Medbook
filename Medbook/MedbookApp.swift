//
//  MedbookApp.swift
//  Medbook
//
//  Created by Aswin Gopinathan on 05/04/25.
//

import SwiftUI
import SwiftData
import netfox

@main
struct MedbookApp: App {
    @StateObject private var navigationManager = NavigationManager()
    @State var container: ModelContainer?
    
    init() {
        //Start the netfox instance to log network calls for debugging
        //TODO: put this inside a DEBUG flag
        NFX.sharedInstance().start()
    }

    var body: some Scene {
        WindowGroup {
            if let container {
                NavigationStack(path: $navigationManager.navigationPath) {
                    LandingView()
                        .navigationDestination(for: NavigationScreen.self) { screen in
                            switch screen {
                            case .signup:
                                SignupView(vm: SignupViewModel(modelContext: container.mainContext))
                            case .login:
                                LoginView(vm: LoginViewModel(navigationManager: navigationManager,
                                                             modelContext: container.mainContext))
                            case .home:
                                Text("Home")
                            case .bookmarks:
                                Text("Bookmarks")
                            }
                        }
                }
                .modelContext(container.mainContext)
                .onDisappear {
                    //Stop the netfox instance from loggin network calls for debugging
                    NFX.sharedInstance().stop()
                }
            } else {
                ProgressView()
            }
        }
        .environmentObject(navigationManager)
        .modelContainer(for: [CountryObject.self,
                              UserObject.self])  { result in
            switch result {
            case .success(let container):
                self.container = container
            case .failure(let error):
                print("MedbookApp - Error creating container: \(error)")
            }
        }
    }
}
