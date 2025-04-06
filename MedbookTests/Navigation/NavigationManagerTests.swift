//
//  NavigationManagerTests.swift
//  MedbookTests
//
//  Created by Aswin Gopinathan on 07/04/25.
//

import XCTest
import SwiftUI
@testable import Medbook

class NavigationManagerTests: XCTestCase {

    var navigationManager: NavigationManager!

    override func setUp() {
        super.setUp()
        navigationManager = NavigationManager()
    }

    override func tearDown() {
        navigationManager = nil
        super.tearDown()
    }

    func testNavigateToAppendsScreenToPath() {
        // Given
        let initialCount = navigationManager.navigationPath.count
        let newScreen: NavigationScreen = .home

        // When
        navigationManager.navigateTo(screen: newScreen)

        // Then
        XCTAssertEqual(navigationManager.navigationPath.count, initialCount + 1)
    }

    func testNavigateBackRemovesLastScreenFromPath() {
        // Given
        navigationManager.navigationPath = NavigationPath()
        navigationManager.navigationPath.append(NavigationScreen.signup)
        navigationManager.navigationPath.append(NavigationScreen.login)
        let initialCount = navigationManager.navigationPath.count

        // When
        navigationManager.navigateBack()

        // Then
        XCTAssertEqual(navigationManager.navigationPath.count, initialCount - 1)
    }

    func testNavigateToClearingAllSetsPathToNewScreen() {
        // Given
        navigationManager.navigationPath = NavigationPath()
        let newScreen: NavigationScreen = .landing

        // When
        navigationManager.navigateToClearingAll(screen: newScreen)

        // Then
        XCTAssertEqual(navigationManager.navigationPath.count, 1)
    }

    func testNavigateToClearingAllSetsPathToNewScreenWhenPathIsEmpty() {
        // Given
        let initialCount = navigationManager.navigationPath.count
        let newScreen: NavigationScreen = .signup

        // When
        navigationManager.navigateToClearingAll(screen: newScreen)

        // Then
        XCTAssertEqual(navigationManager.navigationPath.count, 1)
    }

    func testNavigateToMultipleScreens() {
        // Given
        let initialCount = navigationManager.navigationPath.count

        // When
        navigationManager.navigateTo(screen: .signup)
        navigationManager.navigateTo(screen: .login)
        navigationManager.navigateTo(screen: .home)

        // Then
        XCTAssertEqual(navigationManager.navigationPath.count, initialCount + 3)
    }

    func testNavigateBackMultipleTimes() {
        // Given
        navigationManager.navigationPath = NavigationPath()
        navigationManager.navigationPath.append(NavigationScreen.signup)
        navigationManager.navigationPath.append(NavigationScreen.login)
        navigationManager.navigationPath.append(NavigationScreen.bookmarks)
        navigationManager.navigationPath.append(NavigationScreen.landing)

        let initialCount = navigationManager.navigationPath.count

        // When
        navigationManager.navigateBack()
        navigationManager.navigateBack()

        // Then
        XCTAssertEqual(navigationManager.navigationPath.count, initialCount - 2)
    }
}
