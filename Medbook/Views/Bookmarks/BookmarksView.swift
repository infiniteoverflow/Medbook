//
//  BookmarksView.swift
//  Medbook
//
//  Created by Aswin Gopinathan on 06/04/25.
//

import SwiftUI
import SwiftData

struct BookmarksView: View {
    @EnvironmentObject var appState: AppState
    let vm: BookmarksViewModel
    
    init(vm: BookmarksViewModel) {
        self.vm = vm
    }
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(appState.user?.bookmarks ?? [], id: \.self) { book in
                    BookDetailsCardView(bookData: BookData(from: book),
                                        type: .delete,
                                        onBookmarkedStatusChanged: nil,
                                        onDeleteTapped: {
                        withAnimation(.easeOut) {
                            vm.onDeleteTapped(appState: appState,
                                              book: book)
                        }
                    })
                }
            }
        }
        .padding(24)
        .background(ColorConstants.secondary)
        .navigationTitle("Bookmarks")
        .navigationBarTitleDisplayMode(.large)
    }
}
