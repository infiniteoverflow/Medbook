//
//  BookmarksView.swift
//  Medbook
//
//  Created by Aswin Gopinathan on 06/04/25.
//

import SwiftUI
import SwiftData

struct BookmarksView: View {
    @Query(animation: .bouncy) var books: [BookObject]
    let modelContext: ModelContext
    let swiftDataHelper: SwiftDataHelper
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        self.swiftDataHelper = SwiftDataHelper(modelContext: modelContext)
    }
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(books, id: \.self) { book in
                    BookDetailsCardView(bookData: BookData(from: book),
                                        type: .delete,
                                        onBookmarkedStatusChanged: nil,
                                        onDeleteTapped: {
                        withAnimation(.easeOut) {
                            swiftDataHelper.removeData(book)
                            swiftDataHelper.saveData { result in
                                print(result)
                            }
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
