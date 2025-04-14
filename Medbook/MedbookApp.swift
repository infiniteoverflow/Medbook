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
                BaseEntryView(appRouter: AppRouter(vm: AppViewModel(modelContext: container.mainContext)))
                .preferredColorScheme(.light) //Currently supporting only Light mode!
                .modelContext(container.mainContext)
                .onDisappear {
                    //Stop the netfox instance from loggin network calls for debugging
                    #if DEBUG
                    NFX.sharedInstance().stop()
                    #endif
                }
                .environmentObject(appState) //Maintain the state of the app
            } else {
                AppProgressView()
            }
        }
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
}
