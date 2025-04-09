//
//  BookDetailsCardView.swift
//  Medbook
//
//  Created by Aswin Gopinathan on 06/04/25.
//

import SwiftUI
import Kingfisher

enum BookDetailsCardTrailingIconType {
    case delete
    case bookmark
}

struct BookDetailsCardView: View {
    var bookData: BookData
    let type: BookDetailsCardTrailingIconType
    @State private var bookmarked = false
    var onBookmarkedStatusChanged: ((Bool) -> Void)?
    var onDeleteTapped: (() -> Void)?
    
    init(bookData: BookData,
         type: BookDetailsCardTrailingIconType,
         onBookmarkedStatusChanged: ((Bool) -> Void)?,
         onDeleteTapped: (() -> Void)?) {
        self.bookData = bookData
        self.type = type
        self.onBookmarkedStatusChanged = onBookmarkedStatusChanged
        self.onDeleteTapped = onDeleteTapped
    }
    
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
            
            AnyView(getTrailingView(for: type))
            
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(ColorConstants.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private func getTrailingView(for type: BookDetailsCardTrailingIconType) -> any View {
        switch type {
        case .delete:
            return BookDetailsTrailingIconView(icon: "xmark.bin.fill",
                                               color: ColorConstants.red,
                                               height: 20,
                                               width: 20) {
                withAnimation {
                    onDeleteTapped?()
                }
            }
        case .bookmark:
            if bookData.isBookmarked == true || bookmarked {
                return BookDetailsTrailingIconView(icon: "bookmark.fill", color: ColorConstants.green) {
                    withAnimation(.easeInOut) {
                        bookmarked.toggle()
                        onBookmarkedStatusChanged?(bookmarked)
                    }
                }
            } else {
                return BookDetailsTrailingIconView(icon: "bookmark", color: ColorConstants.black) {
                        withAnimation(.easeInOut) {
                            bookmarked.toggle()
                            onBookmarkedStatusChanged?(bookmarked)
                        }
                    }
            }
        }
    }
}

struct BookDetailsTrailingIconView: View {
    let icon: String
    let color: Color
    let height: CGFloat
    let width: CGFloat
    let onTap: () -> Void
    
    init(icon: String,
         color: Color,
         height: CGFloat = 30,
         width: CGFloat = 20,
         onTap: @escaping () -> Void) {
        self.icon = icon
        self.color = color
        self.height = height
        self.width = width
        self.onTap = onTap
    }
    
    var body: some View {
        Image(systemName: icon)
                .resizable()
                .frame(width: width, height: height)
                .foregroundStyle(color)
                .onTapGesture {
                    onTap()
                }
                .padding(.leading, 16)
                .bold()
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
