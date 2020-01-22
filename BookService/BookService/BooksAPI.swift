//
//  BooksAPI.swift
//  BookService
//
//  Created by David Calixto on 30/12/19.
//  Copyright © 2019 David Calixto. All rights reserved.
//

import Foundation
import Combine
final public class BooksAPI {
    
    public typealias key = String
    public typealias ErrorType = Never
    public typealias PublisherType = AnyPublisher<Data?, ErrorType>
    
    let searcher = BookSearcher()
    let imageLoader = BookImageLoader.make()
    public init() { }
}
extension BooksAPI: APICallable {
    
    public func searh(_ query: String) -> AnyPublisher<Data, APIError> {
        return searcher.searh(query)
    }
}

extension BooksAPI: ImageLoader {
    
    public func data(for id: String) -> AnyPublisher<Data?, BooksAPI.ErrorType> {
        return imageLoader.data(for: id)
    }
}


