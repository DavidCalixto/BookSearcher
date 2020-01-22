//
//  ImageLoaderTests.swift
//  BookServiceTests
//
//  Created by David Calixto on 28/12/19.
//  Copyright © 2019 David Calixto. All rights reserved.
//

import XCTest
import Combine
@testable import BookService
class ImageLoaderTest: XCTestCase {
    var sut: InMemoryImageLoader!
    
    override func setUp() {
        sut = InMemoryImageLoader()
    }
    
    override func tearDown() {
        sut = nil
    }

    func testData_givenAnId_retriveNil() {
        let id = "nil"
        let  _ = sut.data(for: id).sink { data in
            XCTAssertNil(data)
        }
        
    }
    
    func testSave_givenDataAndId_saveData() {
        let id = "notNil"
        let dataFromBytes = Data([0x00, 0x01, 0x02, 0x03])
        sut.save(dataFromBytes, for: id)
       let _ =  sut.data(for: id).sink { data in
            XCTAssertEqual(dataFromBytes, data)
        }
        
    }
}
