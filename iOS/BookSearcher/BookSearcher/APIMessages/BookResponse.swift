//
//  BookResponse.swift
//  BookSearcher
//
//  Created by David Calixto on 30/12/19.
//  Copyright © 2019 David Calixto. All rights reserved.
//

import Foundation
struct APIResponse: Decodable {
    let items: [BookResponse]
}
struct BookResponse: Decodable {
    let id: String
    let volumeInfo: VolumeInfo
    
    
    struct VolumeInfo: Decodable {
        let title: String
        let authors: [String]?
        let publisher: String?
    }
}
