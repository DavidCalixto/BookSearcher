//
//  BookViewModel.swift
//  BookSearcher
//
//  Created by David Calixto on 30/12/19.
//  Copyright © 2019 David Calixto. All rights reserved.
//

import UIKit
import Combine
struct BookViewModel {
    let id: String
    let title: String
    let authors: [String]?
    let cover: AnyPublisher<UIImage?, Never>
    
    init(from book: Book , cover: AnyPublisher<UIImage?, Never>) {
        self.id = book.id
        self.title = book.title
        self.authors = book.authors
        self.cover = cover.replaceEmpty(with: #imageLiteral(resourceName: "bookPlaceholder")).eraseToAnyPublisher()
    }
    
    var description: String {
        return "\(title)" + "\n|\(authors?.joined(separator: " " ) ?? "")"
    }
}
extension BookViewModel: Hashable {
    static func == (lhs: BookViewModel, rhs: BookViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
