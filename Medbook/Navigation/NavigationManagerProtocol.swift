//
//  NavigationManagerProtocol.swift
//  Medbook
//
//  Created by Aswin Gopinathan on 05/04/25.
//

enum NavigationScreen {
    case signup
    case login
    case home
    case bookmarks
}

protocol NavigationManagerProtocol {
    func navigateTo(screen: NavigationScreen)
    func navigateBack()
    func navigateToClearingAll(screen: NavigationScreen)
}
