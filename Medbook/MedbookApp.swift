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
    @ObservedObject var vm: AppViewModel = AppViewModel()
    
    init() {
        //Start the netfox instance to log network calls for debugging
        #if DEBUG
        NFX.sharedInstance().start()
        #endif
    }

    var body: some Scene {
        WindowGroup {
            if let container {
                NavigationStack(path: $navigationManager.navigationPath) {
                    VStack {
                        switch vm.userState {
                        case .loading:
                            AppProgressView()
                        case .loggedIn:
                            HomePageView(vm: HomePageViewModel(navigationManager: navigationManager,
                                                               modelContext: container.mainContext))
                        case .newUser:
                            LandingView()
                        }
                    }
                    .navigationDestination(for: NavigationScreen.self) { screen in
                        switch screen {
                        case .signup:
                            SignupView(vm: SignupViewModel(modelContext: container.mainContext))
                        case .login:
                            LoginView(vm: LoginViewModel(navigationManager: navigationManager,
                                                         modelContext: container.mainContext))
                        case .home:
                            HomePageView(vm: HomePageViewModel(navigationManager: navigationManager,
                                                               modelContext: container.mainContext))
                        case .bookmarks:
                            BookmarksView()
                        case .landing:
                            LandingView()
                        }
                    }
                }
                
                .preferredColorScheme(.light)
                .modelContext(container.mainContext)
                .onDisappear {
                    //Stop the netfox instance from loggin network calls for debugging
                    #if DEBUG
                    NFX.sharedInstance().stop()
                    #endif
                }
            } else {
                AppProgressView()
            }
        }
        .environmentObject(navigationManager)
        .modelContainer(for: [CountryObject.self,
                              UserObject.self,
                              BookObject.self,
                              AppPreferenceObject.self])  { result in
            switch result {
            case .success(let container):
                self.container = container
                vm.setModelContext(modelContext: container.mainContext)
                vm.isUserLoggedIn()
            case .failure(let error):
                print("MedbookApp - Error creating container: \(error)")
            }
        }
    }
}
