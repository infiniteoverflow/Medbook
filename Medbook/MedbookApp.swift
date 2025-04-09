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
    //Manager that takes care of the navigation within the app
    @StateObject private var navigationManager = NavigationManager()
    
    //Stores the instance of the ModelContainer that we will be using to work with SwiftData objects
    @State var container: ModelContainer?
    
    //ViewModel for the current view which ideally takes care of the initial navigation
    @State var vm: AppViewModel?
    
    //Maintain the App state
    @StateObject private var appState = AppState()
    
    init() {
        //Start the netfox instance to log network calls for debugging
        #if DEBUG
        DispatchQueue.main.async {
            NFX.sharedInstance().start()
        }
        #endif
    }

    var body: some Scene {
        WindowGroup {
            if let container {
                NavigationStack(path: $navigationManager.navigationPath) {
                    VStack {
                        switch vm?.userState {
                        case .loading: //ModelContainer is getting setup for the flow without which we cannot proceed further
                            AppProgressView()
                        case .loggedIn: //User is already logged-in to the app and should see the HomePage
                            HomePageView(vm: HomePageViewModel(navigationManager: navigationManager,
                                                               modelContext: container.mainContext))
                        case .newUser: //User is a new user and should see the Landing page
                            LandingView()
                        default: //Safety measure in-case ModelContainer is not created and VM is not available
                            AppProgressView()
                        }
                    }
                    .navigationDestination(for: NavigationScreen.self) { screen in
                        AnyView(getNavigationScreen(for: screen,
                                                    container: container))
                    }
                }
                .preferredColorScheme(.light) //Currently supporting only Light mode!
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
        .environmentObject(navigationManager) //We need a common instance of NavigationManager throughout the App Session
        .environmentObject(appState) //Maintain the state of the app
        .modelContainer(for: [CountryObject.self, //Represents the Country object
                              UserObject.self, //Represents the details of the user after authentication
                              BookObject.self, //Represents each book item
                              AppPreferenceObject.self //Represents common preference items to run the app
                             ])  { result in
            handleContainerResult(result: result)
        }
    }
    
    //Handle the result of setting up a ModelContainer
    private func handleContainerResult(result: Result<ModelContainer, any Error>) {
        switch result {
        case .success(let container):
            self.container = container
            vm = AppViewModel(modelContext: container.mainContext)
            appState.user = vm?.currentUser
        case .failure(let error):
            print("MedbookApp - Error creating container: \(error)")
        }
    }
    
    //Return the ScreenView based on the screen enum
    private func getNavigationScreen(for screen: NavigationScreen,
                                     container: ModelContainer) -> any View {
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
            BookmarksView(modelContext: container.mainContext)
        case .landing:
            LandingView()
        }
    }
}
