//
//  BookmarksViewModel.swift
//  Medbook
//
//  Created by Aswin Gopinathan on 14/04/25.
//

import Foundation
import SwiftData
import SwiftUI

final class BookmarksViewModel: ObservableObject {
    let modelContext: ModelContext
    let swiftDataHelper: SwiftDataHelper?
    let router: BookmarksRouter
    
    init(modelContext: ModelContext,
         router: BookmarksRouter) {
        self.modelContext = modelContext
        self.router = router
        self.swiftDataHelper = SwiftDataHelper(modelContext: modelContext)
    }
    
    func onDeleteTapped(appState: AppState, book: BookObject) {
        appState.user?.bookmarks.removeAll(where: { obj in
            obj.identifier == book.identifier
        })
        swiftDataHelper?.removeData(book)
        swiftDataHelper?.saveData { result in
            print(result)
        }
    }
}
