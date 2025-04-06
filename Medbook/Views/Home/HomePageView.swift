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
    @State private var isAtBottom = false
    @State private var contentHeight: CGFloat = 0
    
    init(vm: HomePageViewModel) {
        self.vm = vm
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Which topic interests\nyou today?")
                    .font(.system(size: 28, weight: .bold))
                    .padding(16)
                    .foregroundStyle(ColorConstants.black)
                
                if vm.isBookListingLoading {
                    AppProgressView()
                } else if !vm.books.isEmpty {
                    HStack(spacing: 16) {
                        Text("Sort By:")
                        
                        HStack(spacing: 8) {
                            ForEach(vm.sortCategories, id: \.self) { category in
                                Text(category.rawValue)
                                    .padding(8)
                                    .background(vm.selectedSortCategory == category ? ColorConstants.primary : ColorConstants.secondary)
                                    .clipShape(RoundedRectangle(cornerRadius: 4))
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
                    
                    LazyVStack(spacing: 16) {
                        ForEach(Array(vm.books.enumerated()), id: \.element.id) { index, book in
                            BookDetailsCardView(bookData: book) { status in
                                vm.bookmarkStatusChanged(for: book, status: status)
                            }
                                .onAppear {
                                    if index == vm.books.count - 1 {
                                        print("Fetching new books")
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
        .searchable(text: $vm.searchText)
        .searchPresentationToolbarBehavior(.avoidHidingContent)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack(spacing: 16) {
                    Image(systemName: "book.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .bold()
                    
                    Text("MedBook")
                        .font(.system(size: 24, weight: .bold))
                }
                .foregroundStyle(ColorConstants.black)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: 16) {
                    Image(systemName: "bookmark.fill")
                        .resizable()
                        .frame(width: 30, height: 35)
                        .onTapGesture {
                            vm.navigationManager.navigateTo(screen: .bookmarks)
                        }
                    
                    Image(systemName: "delete.left")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundStyle(ColorConstants.red)
                        .onTapGesture {
                            vm.logout()
                        }
                }
                .foregroundStyle(ColorConstants.black)
            }
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
