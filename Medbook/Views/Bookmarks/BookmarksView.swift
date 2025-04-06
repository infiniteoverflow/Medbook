//
//  BookmarksView.swift
//  Medbook
//
//  Created by Aswin Gopinathan on 06/04/25.
//

import SwiftUI
import SwiftData

struct BookmarksView: View {
    @Environment(\.modelContext) var modelContext
    @Query var books: [BookObject]
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(books, id: \.self) { book in
                    BookDetailsCardView(bookData: BookData(from: book)) { status in
                        //Do nothing for now
                    }
                }
            }
        }
        .padding(24)
        .background(ColorConstants.secondary)
        .navigationTitle("Bookmarks")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    BookmarksView()
}
