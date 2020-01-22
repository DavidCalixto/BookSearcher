//
//  SearchViewModelTests.swift
//  BookSearcherTests
//
//  Created by David Calixto on 30/12/19.
//  Copyright © 2019 David Calixto. All rights reserved.
//

import XCTest
import Combine
@testable import BookSearcher
class SearchViewModelTests: XCTestCase {

    var sut: SearchViewModel!
    override func setUp() {
        sut = SearchViewModel()
    }

    override func tearDown() {
        sut = nil
    }
    
    func testGivenAquery_should_chainToOtherPublisher() {
        let search = PassthroughSubject <String, Never>()
        let query = "roberto"
        let expectation = XCTestExpectation()
        var cancellables: [AnyCancellable] = []
        let output = sut.output(for: search.eraseToAnyPublisher()).sink(receiveCompletion: { (completion) in
            switch completion {
            case .finished:
                break
            case .failure( let error):
                XCTFail(error.localizedDescription)
            }
        }) { (books) in
            expectation.fulfill()
            XCTAssertFalse(books.count == 0)
        }
        output.store(in: &cancellables)
        search.send(query)
        wait(for: [expectation], timeout: 1)
    }
}


