//
//  BookDetailsCardView.swift
//  Medbook
//
//  Created by Aswin Gopinathan on 06/04/25.
//

import SwiftUI
import Kingfisher

struct BookDetailsCardView: View {
    let bookData: BookData
    @State private var bookmarked = false
    var onBookmarkedStatusChanged: (Bool) -> Void
    
    var body: some View {
        HStack {
            KFImage(URL(string: UrlConstants.coverImage(coverI: bookData.coverI ?? 0)))
                .placeholder {
                    PlaceholderImageView()
                }
                .onFailureImage(.bookPlaceholder)
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 4))
                .scaledToFit()
                .frame(width: 45, height: 70)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(bookData.title ?? "")
                    .foregroundStyle(ColorConstants.black)
                    .bold()
                
                HStack(spacing: 24) {
                    Text(bookData.authorName?.first ?? "")
                        .foregroundStyle(ColorConstants.primary)
                        .font(.system(size: 14))
                    
                    HStack {
                        Image(systemName: "star.fill")
                            .frame(width: 15, height: 15)
                            .foregroundStyle(.orange)
                        Text("4.4")
                            .foregroundStyle(ColorConstants.black)
                            .font(.system(size: 14))
                    }
                    
                    HStack {
                        Image(systemName: "calendar")
                            .frame(width: 15, height: 15)
                            .foregroundStyle(.orange)
                        Text(String(bookData.firstPublishYear ?? 0))
                            .foregroundStyle(ColorConstants.black)
                            .font(.system(size: 14))
                        
                    }
                }
            }
            
            Spacer()
            
            if bookmarked {
                Image(systemName: "bookmark.fill")
                    .resizable()
                    .frame(width: 20, height: 30)
                    .foregroundStyle(ColorConstants.green)
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            bookmarked.toggle()
                            onBookmarkedStatusChanged(bookmarked)
                        }
                    }
                    .padding(.leading, 16)
            } else {
                Image(systemName: "bookmark")
                    .resizable()
                    .frame(width: 20, height: 30)
                    .foregroundStyle(ColorConstants.black)
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            bookmarked.toggle()
                            onBookmarkedStatusChanged(bookmarked)
                        }
                    }
                    .padding(.leading, 16)
            }
            
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(ColorConstants.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    BookDetailsCardView(bookData: BookData(authorName: ["Aswin Gopinathan"],
                                           coverI: 9269962,
                                           title: "Living my life!",
                                           firstPublishYear: 2032)) { status in
        print(status)
    }
}

struct PlaceholderImageView: View {
    var body: some View {
        Image("book-placeholder")
            .resizable()
            .clipShape(RoundedRectangle(cornerRadius: 4))
            .scaledToFit()
            .frame(width: 45, height: 70)
    }
}
