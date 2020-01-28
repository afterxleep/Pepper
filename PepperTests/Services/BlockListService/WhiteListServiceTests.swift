//
//  WhiteListServiceTests.swift
//  PepperTests
//
//  Created by Daniel Bernal on 19/10/19.
//  Copyright © 2019 Daniel Bernal. All rights reserved.
//

import XCTest
@testable import Pepper

class WhiteListServiceTests: XCTestCase {
    
    private let identifier = BlockLists.DummyList.identifier
    private let testFilterAddId = "test-filter-add-id"
    private let testFilterRemoveId = "test-filter-remove-id"
    private let listStorage = DummyStorage()
    
    func testWhenReadingWhiteListThenItReturnsData() {
        var listService = UserWhiteList(listStore: listStorage, networkClient: nil)
        listService.identifier = identifier.rawValue
        let expectation = XCTestExpectation(description: "testWhenReadingWhiteListThenItReturnsData")
        
        listService.read { (result) in
            if case .success(let data) = result {
                XCTAssert(data.count > 0, "Filter Rules should be returned")
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 10)
    }
}
