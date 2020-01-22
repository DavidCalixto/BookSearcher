//
//  BookSearcherTests.swift
//  BookServiceTests
//
//  Created by David Calixto on 30/12/19.
//  Copyright © 2019 David Calixto. All rights reserved.
//

import XCTest
import Combine
@testable import BookService
class BookSearcherTests: XCTestCase {

    var sut: BookSearcher!
    
    override func setUp() {
        sut = BookSearcher()
    }

    override func tearDown() {
        sut = nil
    }
    
    func testGivenAQuery_should_callRemoteAPI() {
        
        let expectation = XCTestExpectation()
        var cancelables: [AnyCancellable] = []
        let cancellable = sut.searh("roberto").sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                expectation.fulfill()
                break
            case .failure(let apiError):
                XCTFail(apiError.localizedDescription)
            }
        }) { (data) in
            expectation.fulfill()
            XCTAssertNotNil(data)
        }
        cancellable.store(in: &cancelables)
        
        wait(for: [expectation], timeout: 5)
    }

}
