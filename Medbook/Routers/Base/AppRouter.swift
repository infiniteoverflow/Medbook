//
//  AppRouter.swift
//  Medbook
//
//  Created by Aswin Gopinathan on 12/04/25.
//

import Foundation
import SwiftUI
import SwiftData

protocol NavigationCoordinatorProtocol {
    func push(router: any RoutableView)
    func pushClearingAll(router: any RoutableView)
    func pop()
    func popTillRoot()
}

final class AppRouter: NavigationCoordinatorProtocol, ObservableObject {
    @Published var path = NavigationPath()
    private var vm: AppViewModel
    
    init(vm: AppViewModel) {
        self.vm = vm
    }
    
    func push(router: any RoutableView) {
        DispatchQueue.main.async { [weak self] in
            guard let self else {
                return
            }
            let routableView = AnyRoutableView(router)
            path.append(routableView)
        }
    }
    
    func pushClearingAll(router: any RoutableView) {
        DispatchQueue.main.async { [weak self] in
            guard let self else {
                return
            }
            let routableView = AnyRoutableView(router)
            path = NavigationPath()
            path.append(routableView)
        }
    }
    
    func pop() {
        DispatchQueue.main.async { [weak self] in
            guard let self else {
                return
            }
            
            path.removeLast()
        }
    }
    
    func popTillRoot() {
        DispatchQueue.main.async { [weak self] in
            guard let self else {
                return
            }
            
            path = NavigationPath()
        }
    }
    
    func getInitialRouter() -> any RoutableView {
        let router: any RoutableView
        if vm.isUserLoggedIn() {
            router = HomePageRouter(navigationCoordinator: self,
                                    modelContext: vm.modelContext)
        } else {
            router = LandingRouter(navigationCoordinator: self,
                                   modelContext: vm.modelContext)
        }
        return router
    }
}
