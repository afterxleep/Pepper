//
//  EasyListServiceTests.swift
//  PepperTests
//
//  Created by Daniel Bernal on 19/10/19.
//  Copyright © 2019 Daniel Bernal. All rights reserved.
//

import XCTest
@testable import Pepper

class EasyListServiceTests: XCTestCase {
    
    func testWhenReadingEasyListThenItReturnsData() {
        let expectation = XCTestExpectation(description: "testWhenReadingEasyListThenItReturnsData")
        let listStore = DummyStorage()
        let networkClient = DummyNetworkClient(requestType: .JSONList)
        var listService = EasyList(listStore: listStore, networkClient: networkClient)
        listService.identifier = BlockLists.DummyList.identifier.rawValue
        listService.read { (result) in            
            if case .success(let data) = result {
                XCTAssert(data.count > 0, "Filter Rules should be returned")
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 10)
        
    }
 
    func testWhenUpdatingEasyListThenFinishesCorrectly() {
        let expectation = XCTestExpectation(description: "testWhenUpdatingEasyListThenFinishesCorrectly")
        let listStore = DummyStorage()
        let networkClient = DummyNetworkClient(requestType: .JSONList)
        let listService = EasyList(listStore: listStore, networkClient: networkClient)
        listService.update { (result) in
            if case .success = result {
                XCTAssert(true, "Filter Rules should be returned")
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 10)
        
    }
 
}
