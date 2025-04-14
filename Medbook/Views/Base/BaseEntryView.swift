//
//  BaseEntryView.swift
//  Medbook
//
//  Created by Aswin Gopinathan on 12/04/25.
//

import Foundation
import SwiftUI
import SwiftData

struct BaseEntryView: View {
    @Environment(\.modelContext) var modelContext: ModelContext
    @StateObject var appRouter: AppRouter

    var body: some View {
        NavigationStack(path: $appRouter.path) {
            appRouter.getInitialRouter().makeView()
            .navigationDestination(for: AnyRoutableView.self) { routableView in
                routableView.makeView()
            }
        }
    }
}
