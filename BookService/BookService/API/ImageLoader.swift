//
//  ImageLoader.swift
//  BookService
//
//  Created by David Calixto on 28/12/19.
//  Copyright © 2019 David Calixto. All rights reserved.
//

import Foundation
import Combine

protocol ImageLoader: class {
    associatedtype key: Hashable
    associatedtype ErrorType: Error
    associatedtype PublisherType: Publisher
    func data(for id: key) -> PublisherType
}
