//
//  HomePageViewModel.swift
//  Medbook
//
//  Created by Aswin Gopinathan on 06/04/25.
//

import SwiftUI
import SwiftData
import Foundation
import Combine

enum SortCategories: String {
    case title = "Title"
    case author = "Author"
    case yearOfPublish = "Publish Year"
}

final class HomePageViewModel: ObservableObject, HomePageViewModelProtocol {
    let navigationManager: NavigationManager
    let modelContext: ModelContext
    var offset = 0
    var limit = 10
    
    @Published var books: [BookData] = []
    @Published var isBookListingLoading = false
    @Published var isLoadingMoreBooks = false
    @Published var searchText: String = ""
    @Published var selectedSortCategory: SortCategories = .title
    var bookmarkedBooks: [String: BookObject] = [:]

    private var cancellables = Set<AnyCancellable>()
    private var swiftDataHelper: SwiftDataHelper
    let sortCategories: [SortCategories] = [.title, .author, .yearOfPublish]
    
    init(navigationManager: NavigationManager,
         modelContext: ModelContext) {
        self.navigationManager = navigationManager
        self.modelContext = modelContext
        self.swiftDataHelper = SwiftDataHelper(modelContext: modelContext)
        
        listenToSearchText()
    }
    
    func logout() {
        clearAppPreferenceData()
        navigationManager.navigateToClearingAll(screen: .landing)
    }
        
    func fetchBooksData() {
        AGNetworkClient.shared.makeRequest(urlString: UrlConstants.bookListing(title: searchText,
                                                                               limit: limit,
                                                                               offset: offset),
                                           httpMethod: .get,
                                           type: BookListingData.self) { [weak self] error, response in
            DispatchQueue.main.async { [weak self] in
                guard let self else {
                    return
                }
                
                isBookListingLoading = false
                isLoadingMoreBooks = false
                
                if let error {
                    print(error.localizedDescription)
                    //TODO: Handle error scenario
                    return
                }
                
                guard let newBooks = response?.docs else { return }
                                
                // Sort new books and filter them
                rearrangeNewBooks(newBooks)
                
                offset += limit
            }
        }
    }
    
    func sortBasedOnCategory(books: [BookData], category: SortCategories) -> [BookData] {
        var sortedBooks = books.sorted { book1, book2 in
            switch selectedSortCategory {
            case .title:
                book1.title ?? "" < book2.title ?? ""
            case .author:
                book1.authorName?.first ?? "" < book2.authorName?.first ?? ""
            case .yearOfPublish:
                book1.firstPublishYear ?? 0 < book2.firstPublishYear ?? 0
            }
        }
        
        sortedBooks = sortedBooks.map { book in
            if let _ = bookmarkedBooks[book.lendingIdentifier ?? ""] {
                return BookData(authorName: book.authorName,
                                coverI: book.coverI,
                                title: book.title,
                                firstPublishYear: book.firstPublishYear,
                                lendingIdentifier: book.lendingIdentifier,
                                isBookmarked: true)
            }
            
            return book
        }
        
        return sortedBooks
    }
    
    func bookmarkStatusChanged(for book: BookData, status: Bool, user: UserObject?) {
        let bookObject = BookObject(from: book)
        bookObject.isBookmarked = status
        switch status {
        case true:
            user?.bookmarks.append(bookObject)
            bookmarkedBooks[bookObject.identifier] = bookObject
        case false:
            user?.bookmarks.removeAll(where: { obj in
                obj.identifier == bookObject.identifier
            })
            bookmarkedBooks[bookObject.identifier] = nil
        }
        
        if let user {
            swiftDataHelper.storeData(user)
        }
        
        swiftDataHelper.saveData { result in
            switch result {
            case .success:
                print("Success!")
            case .failure:
                print("Failed")
            }
        }
    }
    
    func fetchBookmarks(for user: UserObject?) {
        bookmarkedBooks = [:]
        user?.bookmarks.forEach { obj in
            bookmarkedBooks[obj.identifier] = obj
        }
    }
    
    func recheckBookmarksStatus() {
        books = books.map { book in
            if let _ = bookmarkedBooks[book.lendingIdentifier ?? ""] {
                return book
            }
            
            return BookData(authorName: book.authorName,
                            coverI: book.coverI,
                            title: book.title,
                            firstPublishYear: book.firstPublishYear,
                            lendingIdentifier: book.lendingIdentifier,
                            isBookmarked: false)
        }
    }
    
    private func clearAppPreferenceData() {
        let appPreferenceObjects: [AppPreferenceObject]? = swiftDataHelper.fetchData()
        appPreferenceObjects?.forEach({ obj in
            swiftDataHelper.removeData(obj)
        })
        swiftDataHelper.saveData { result in
            print(result)
        }
    }
    
    private func rearrangeNewBooks(_ newBooks: [BookData]) {
        if self.books.isEmpty {
            books = sortBasedOnCategory(books: newBooks,
                                        category: selectedSortCategory)
            return
        }
        
        // Insert each book with animation
        for (_ , newBook) in newBooks.enumerated() {
            //Check for duplicate books, if it exists, skip this book
            if let _ = books.first(where: { data in
                newBook.title == data.title
            }) {
                continue
            }
            // Find the correct insertion index
            let insertIndex = books.firstIndex(where: {
                switch selectedSortCategory {
                case .title:
                    $0.title ?? "" > newBook.title ?? ""
                case .author:
                    $0.authorName?.first ?? "" > newBook.authorName?.first ?? ""
                case .yearOfPublish:
                    $0.firstPublishYear ?? 0 > newBook.firstPublishYear ?? 0
                }
            }) ?? newBooks.endIndex
            
            withAnimation(.bouncy(duration: 0.6)) { [weak self] in
                guard let self else {
                    return
                }
                self.books.insert(newBook, at: insertIndex)
            }
        }
    }
    
    private func listenToSearchText() {
        $searchText
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] value in
                guard let self else {
                    return
                }
                offset = 0
                if value.count >= 3 {
                    isBookListingLoading = true
                    books = []
                    fetchBooksData()
                } else {
                    isBookListingLoading = false
                }
            }
            .store(in: &cancellables)
    }
}
