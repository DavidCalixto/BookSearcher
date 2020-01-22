//
//  RemoteImageLoader.swift
//  BookService
//
//  Created by David Calixto on 29/12/19.
//  Copyright © 2019 David Calixto. All rights reserved.
//

import Foundation
final class RemoteImageLoader: ImageLoader {
    
    typealias key = String
    typealias ErrorType = URLError
    typealias PublisherType = URLSession.DataTaskPublisher
    
    var endpoint: Endpoint!
    
    
    init(_ endpoint: Endpoint){
        self.endpoint = endpoint
    }
    
    func data(for id: key) -> PublisherType {
        configImageBookURL(for: id)
        return getDataTaskPublisher()
    }
  
        func configImageBookURL( for id: key, coverSize: BookCoverSize = .small) {
            endpoint.queryItems = [
            "printsec": "frontcover",
            "img": "1",
            "edge": "curl",
            "source": "gbs_api"]
            endpoint.path = "/books/content"
            endpoint.queryItems["zoom"] = "\(coverSize.rawValue)"
            endpoint.queryItems["id"] = id
            
        }
        
            private func getDataTaskPublisher() -> URLSession.DataTaskPublisher {
                guard let url = endpoint.url else { fatalError("URLs cannot be created")}
                return URLSession.shared.dataTaskPublisher(for: url)
            }
}

