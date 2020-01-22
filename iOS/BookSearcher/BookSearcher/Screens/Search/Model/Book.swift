//
//  Book.swift
//  BookSearcher
//
//  Created by David Calixto on 30/12/19.
//  Copyright © 2019 David Calixto. All rights reserved.
//

import Foundation
struct Book {
    let id: String
    let title: String
    let authors: [String]?
    
    init(from response: BookResponse) {
        id = response.id
        title = response.volumeInfo.title
        authors = response.volumeInfo.authors
    }
}
