//
//  BookmarksRouter.swift
//  Medbook
//
//  Created by Aswin Gopinathan on 14/04/25.
//

import Foundation
import SwiftUI
import SwiftData

final class BookmarksRouter: RoutableView {
    let uuid = UUID()
    let modelContext: ModelContext
    let rootCoordinator: NavigationCoordinatorProtocol
    
    init(modelContext: ModelContext,
         rootCoordinator: NavigationCoordinatorProtocol) {
        self.modelContext = modelContext
        self.rootCoordinator = rootCoordinator
    }
    
    func makeView() -> AnyView {
        let bookmarksVM = BookmarksViewModel(modelContext: modelContext,
                                             router: self)
        return AnyView(BookmarksView(vm: bookmarksVM))
    }
}

extension BookmarksRouter {
    static func == (lhs: BookmarksRouter, rhs: BookmarksRouter) -> Bool {
        lhs.uuid == rhs.uuid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
