//
//  HomePageView.swift
//  Medbook
//
//  Created by Aswin Gopinathan on 06/04/25.
//

import SwiftUI
import SwiftData

struct HomePageView: View {
    @ObservedObject var vm: HomePageViewModel
    @State var isSearchPresented = true
    
    struct Constants {
        static let titleFontSize: CGFloat = 28
        static let titlePadding: CGFloat = 16
        static let sortBookListSectionSpacing: CGFloat = 16
        static let interSortCategorySpacing: CGFloat = 8
        static let categoryVerticalSpacing: CGFloat = 8
        static let categoryHorizontalSpacing: CGFloat = 8
        static let categoryCornerRadius: CGFloat = 4
        static let interBookSpacing: CGFloat = 16
        static let toolBarItemSpacing: CGFloat = 16
        static let toolBarItemDimension: CGFloat = 30
        static let toolBarTextFontSize: CGFloat = 24
    }
    
    init(vm: HomePageViewModel) {
        self.vm = vm
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(TextConstants.Home.title)
                    .font(.system(size: Constants.titleFontSize, weight: .bold))
                    .padding(Constants.titlePadding)
                    .foregroundStyle(ColorConstants.black)
                
                if vm.isBookListingLoading {
                    AppProgressView()
                } else if !vm.books.isEmpty {
                    HStack(spacing: Constants.sortBookListSectionSpacing) {
                        Text(TextConstants.Home.sortTitle)
                        
                        HStack(spacing: Constants.interSortCategorySpacing) {
                            ForEach(vm.sortCategories, id: \.self) { category in
                                Text(category.rawValue)
                                    .padding(.vertical, Constants.categoryVerticalSpacing)
                                    .padding(.horizontal, Constants.categoryHorizontalSpacing)
                                    .background(vm.selectedSortCategory == category ? ColorConstants.primary : ColorConstants.secondary)
                                    .clipShape(RoundedRectangle(cornerRadius: Constants.categoryCornerRadius))
                                    .onTapGesture {
                                        vm.selectedSortCategory = category
                                        vm.books = vm.sortBasedOnCategory(books: vm.books,
                                                                          category: category)
                                    }
                                    .bold()
                            }
                        }
                    }
                    .foregroundStyle(ColorConstants.black)
                    .padding()
                    
                    LazyVStack(spacing: Constants.interBookSpacing) {
                        ForEach(Array(vm.books.enumerated()), id: \.element.id) { index, book in
                            BookDetailsCardView(bookData: book,
                                                type: .bookmark,
                                                onBookmarkedStatusChanged: { status in
                                vm.bookmarkStatusChanged(for: book, status: status)
                            },
                                                onDeleteTapped: nil)
                                .onAppear {
                                    if index == vm.books.count - 1 {
                                        vm.isLoadingMoreBooks = true
                                        vm.fetchBooksData()
                                    }
                                }
                        }
                    }
                    .padding()
                    
                    if vm.isLoadingMoreBooks {
                        AppProgressView()
                    }
                }
                
                HStack {
                    Spacer()
                }
            }
        }
        .background(ColorConstants.secondary)
        .searchable(text: $vm.searchText, isPresented: $isSearchPresented)
        .searchPresentationToolbarBehavior(.avoidHidingContent)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack(spacing: Constants.toolBarItemSpacing) {
                    Image(systemName: TextConstants.Home.navBarLeadingPrimaryIcon)
                        .resizable()
                        .frame(width: Constants.toolBarItemDimension, height: Constants.toolBarItemDimension)
                        .bold()
                    
                    Text(TextConstants.Home.navBarLeadingSecondaryText)
                        .font(.system(size: Constants.toolBarTextFontSize,
                                      weight: .bold))
                }
                .foregroundStyle(ColorConstants.black)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: Constants.toolBarItemSpacing) {
                    NavigationLink {
                        BookmarksView(modelContext: vm.modelContext)
                    } label: {
                        Image(systemName: TextConstants.Home.navBarTrailingPrimaryIcon)
                            .resizable()
                            .frame(width: Constants.toolBarItemDimension, height: Constants.toolBarItemDimension + 5)
                    }
                        
                    
                    Image(systemName: TextConstants.Home.navBarTrailingSecondaryIcon)
                        .resizable()
                        .frame(width: Constants.toolBarItemDimension, height: Constants.toolBarItemDimension)
                        .foregroundStyle(ColorConstants.red)
                        .onTapGesture {
                            vm.logout()
                        }
                }
                .foregroundStyle(ColorConstants.black)
            }
        }
        .onAppear {
            isSearchPresented = true // Show the search bar when the view appears
        }
    }
}

#Preview {
    @Previewable @Environment(\.modelContext) var modelContext
    @Previewable @State var container: ModelContainer?
    
    NavigationView {
        if let container {
            HomePageView(vm: HomePageViewModel(navigationManager: NavigationManager(),
                                               modelContext: container.mainContext))
        } else {
            AppProgressView()
        }
    }
    .modelContainer(for: [CountryObject.self,
                          UserObject.self])  { result in
        switch result {
        case .success(let previewContainer):
            container = previewContainer
        case .failure(let error):
            print("MedbookApp - Error creating container: \(error)")
        }
    }
    
}
