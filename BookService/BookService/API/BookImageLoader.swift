//
//  BookImageLoader.swift
//  BookService
//
//  Created by David Calixto on 30/12/19.
//  Copyright © 2019 David Calixto. All rights reserved.
//

import Foundation
import Combine
final class BookImageLoader: ImageLoader {
   
    typealias key = String
    typealias ErrorType = Never
    typealias PublisherType = AnyPublisher<Data?, ErrorType>
    
    private let remoteImageLoader: RemoteImageLoader
    private let localImageLoader: InMemoryImageLoader
    
    private enum ImageError: Error {
        case notFound
    }
    
    class func make() -> BookImageLoader {
        return BookImageLoader(RemoteImageLoader(ImageEndpoint("books.google.com")), localImageLoader: InMemoryImageLoader())
    }
    
    init(_ remoteImageLoader: RemoteImageLoader, localImageLoader: InMemoryImageLoader) {
        self.remoteImageLoader = remoteImageLoader
        self.localImageLoader = localImageLoader
    }
    
    
    func data(for id: key) -> PublisherType {
        
        return getLocalOrRemoteData(for: id)
    }
    
        private func getLocalOrRemoteData(for id: key) -> PublisherType {
               let cancelable = localImageLoader.data(for: id)
                .flatMap {[unowned self] (data) -> PublisherType in
                   if data == nil {  return self.getRemoteImage(for: id) }
                   return Just<Data?>(data).eraseToAnyPublisher()
               }
               return cancelable.eraseToAnyPublisher()
           }
        
            private func getRemoteImage( for id: key) -> PublisherType {
                let cancelable = remoteImageLoader.data(for: id)
                    .map { [unowned self] in
                    self.saveImageData($0.data, for: id)
                    return $0.data }
                    .catch { (error) -> Just<Data?> in
                        return Just<Data?>(nil)
                    }
                return cancelable.eraseToAnyPublisher()
            }
        
                private func saveImageData(_ data: Data, for id: key){
                    localImageLoader.save(data, for: id)
                }
}
