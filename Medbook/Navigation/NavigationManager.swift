//
//  NavigationManager.swift
//  Medbook
//
//  Created by Aswin Gopinathan on 05/04/25.
//

import SwiftUI

final class NavigationManager: ObservableObject, NavigationManagerProtocol {
    @Published var navigationPath =  NavigationPath()
    
    func navigateTo(screen: NavigationScreen) {
        navigationPath.append(screen)
    }
    
    func navigateBack() {
        navigationPath.removeLast()
    }
    
    func navigateToClearingAll(screen: NavigationScreen) {
        if navigationPath.isEmpty {
            navigationPath.append(screen)
        } else {
            navigationPath = NavigationPath()
        }
    }
}
