//
//  SearchViewModel.swift
//  BookSearcher
//
//  Created by David Calixto on 30/12/19.
//  Copyright © 2019 David Calixto. All rights reserved.
//

import UIKit
import Combine
import BookService

class SearchViewModel {
    let booksAPI = BooksAPI()
    
    func output(for query: AnyPublisher<String, Never>) -> AnyPublisher<[BookViewModel], Error> {
        let search = query.debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .filter { return $0.isEmpty == false }
            .removeDuplicates()
            .mapError({ error -> APIError in })
            .flatMapLatest{[unowned self] query  in return self.getApiCall(query) }
            .map{ $0.map { (book) -> BookViewModel in
                    BookViewModel(from: book, cover: self.getImage(book.id))
                }
        }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        return search
    }
    
        fileprivate func getApiCall(_ query: String) -> AnyPublisher<[Book], Error> {
            return booksAPI.searh(query)
                .decode(type: APIResponse.self, decoder: JSONDecoder())
                .map { return $0.items.map{ Book(from: $0)} }
                .eraseToAnyPublisher()
        }
    
        fileprivate func getImage(_ id: String) -> AnyPublisher<UIImage?, Never> {
            return booksAPI.data(for: id)
                .flatMap { return Just<UIImage?>(UIImage(data: $0 ?? Data())) }
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
}
