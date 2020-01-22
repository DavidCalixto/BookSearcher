//
//  BookImageLoaderTest.swift
//  BookServiceTests
//
//  Created by David Calixto on 29/12/19.
//  Copyright © 2019 David Calixto. All rights reserved.
//

import XCTest
import Combine
@testable import BookService
class BookImageLoaderTest: XCTestCase {
    var sut: BookImageLoader!
    weak var weakSut: BookImageLoader?
    override func setUp() {
        sut = BookImageLoader.make()
        weakSut = sut
    }
    
    override func tearDown() {
        sut = nil
        XCTAssertNil(weakSut)
    }
    
    func assertHasImageData(for id: String) {
        let expectation = XCTestExpectation()
        var cancellables: [AnyCancellable] = []
        let cancellable = sut.data(for: id).sink { (data) in
            expectation.fulfill()
            XCTAssertTrue(data?.count ?? 0 > 0 )
        }
        cancellable.store(in: &cancellables)
        wait(for: [expectation], timeout: 5)
    }
    
    func testGetRemoteImageData() {
        assertHasImageData(for: "h_4j3eVHMkEC")
    }
    
    func testGetLocalImageDataImageData() {
        assertHasImageData(for: "h_4j3eVHMkEC")
        assertHasImageData(for: "h_4j3eVHMkEC")
    }
}

