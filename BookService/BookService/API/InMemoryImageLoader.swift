//
//  InMemoryImageLoader.swift
//  BookService
//
//  Created by David Calixto on 28/12/19.
//  Copyright © 2019 David Calixto. All rights reserved.
//

import Foundation
import Combine
final class InMemoryImageLoader: ImageLoader {
    
    typealias key = String
    typealias ErrorType = Never
    typealias PublisherType = AnyPublisher<Data?, Never >
    
    private var persistence: ImageCache = ImageCache()
    
    func save(_ data: Data, for key: String) {
        persistence[key] = data
    }
    
    func data(for id: String) -> PublisherType {
        let data = persistence[id]
        return Just(data).eraseToAnyPublisher()
    }
}

final private class ImageCache {
    private let theardlock = NSLock()
    private lazy var cache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.countLimit = 1024 * 1024 * 100
        return cache
    }()
    
    func get(_ key: String) -> Data? {
        theardlock.lock(); defer { theardlock.unlock() }
        return cache.object(forKey: key as AnyObject) as? Data
    }
    
    func set(_ data: Data?, for key: String) {
        theardlock.lock(); defer { theardlock.unlock() }
        guard let object = data else { return removeData(for: key) }
        cache.setObject(object as AnyObject, forKey: key as AnyObject)
    }
    
    func removeData(for key: String) {
        cache.removeObject(forKey: key as AnyObject)
    }
    
    subscript(_ key: String) -> Data? {
        get {
            return get(key)
        }
        set {
            return set(newValue, for: key)
        }
    }
}
