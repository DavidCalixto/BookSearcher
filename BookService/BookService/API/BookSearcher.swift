//
//  BookSearcher.swift
//  BookService
//
//  Created by David Calixto on 30/12/19.
//  Copyright © 2019 David Calixto. All rights reserved.
//

import Foundation
import Combine
public enum APIError: Error {
    case noService
    case noData
}
public protocol APICallable: class {
    func searh(_ query: String) -> AnyPublisher<Data, APIError>
}
final class BookSearcher: APICallable {

    func searh(_ query: String) -> AnyPublisher<Data, APIError> {
        return getRemotePublisher(query)
    }
       fileprivate func getRemotePublisher(_  query: String) -> AnyPublisher< Data, APIError> {
            guard let url = BookEndpoint.bookSearch(query) else { fatalError("URLs cannot be created") }
            return dataTaskPublisher(url)
        }
            fileprivate func dataTaskPublisher(_ url: URL) -> AnyPublisher< Data, APIError> {
               return URLSession.shared.dataTaskPublisher(for: url)
                .map{ return $0.data }
                .mapError { (error) -> APIError in
                    
                    if error.networkUnavailableReason != nil {
                        return APIError.noService
                    }
                    return APIError.noData
                    }.eraseToAnyPublisher()
            }
}
