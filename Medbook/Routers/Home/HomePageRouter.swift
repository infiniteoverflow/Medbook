//
//  HomePageRouter.swift
//  Medbook
//
//  Created by Aswin Gopinathan on 14/04/25.
//

import SwiftUI
import SwiftData

final class HomePageRouter: RoutableView {
    let uuid = UUID()
    let modelContext: ModelContext
    let navigationCoordinator: NavigationCoordinatorProtocol
    
    init(navigationCoordinator: NavigationCoordinatorProtocol,
         modelContext: ModelContext) {
        self.modelContext = modelContext
        self.navigationCoordinator = navigationCoordinator
    }
    
    func makeView() -> AnyView {
        let homePageVM = HomePageViewModel(modelContext: modelContext,
                                           router: self)
        return AnyView(HomePageView(vm: homePageVM))
    }
}

extension HomePageRouter {
    func navigateToBookmarks() {
        let bookmarksRouter = BookmarksRouter(modelContext: modelContext,
                                              rootCoordinator: navigationCoordinator)
        navigationCoordinator.push(router: bookmarksRouter)
    }
}

extension HomePageRouter {
    static func == (lhs: HomePageRouter, rhs: HomePageRouter) -> Bool {
        lhs.uuid == rhs.uuid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
