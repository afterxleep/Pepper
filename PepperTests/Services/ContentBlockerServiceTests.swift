//
//  ContentBlockerServiceTests.swift
//  PepperTests
//
//  Created by Daniel Bernal on 20/10/19.
//  Copyright © 2019 Daniel Bernal. All rights reserved.
//

import XCTest
@testable import Pepper

class ContentBlockerManagerTests: XCTestCase {

    var listContainer = ListContainer()
    var dummyStorage = DummyStorage()
    var contentBlockerHelper = SFCBHelper()
    
    override func setUp() {
        let dummyList = DummyList(listStore: dummyStorage, networkClient: nil)
        listContainer.add(blockList: dummyList)
        let cbManager = ContentBlockerManager(listContainer: listContainer, contentBlockerHelper: contentBlockerHelper)
        let sharedContainerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: cbManager.sharedContainerName)
        guard let destinationURL = sharedContainerURL?.appendingPathComponent(cbManager.outputFileName) else { return }
        try? FileManager.default.removeItem(at: destinationURL)
    }
    
    func testWhenConsolidatingRulesThenRulesAreConsolidated() {
        
        let expectation = XCTestExpectation(description: "testWhenConsolidatingRulesThenRulesAreWrittenToContainer")
        
        let dummyList = DummyList(listStore: dummyStorage, networkClient: nil)
        listContainer.removeAll()
        listContainer.add(blockList: dummyList)
        listContainer.add(blockList: dummyList)
        let cbManager = ContentBlockerManager(listContainer: listContainer, contentBlockerHelper: contentBlockerHelper)
        
        var rulesCount = 0
        dummyList.read { (result) in
            if case .success(let data) = result {
            rulesCount = data.count * 2
            }
        }

        cbManager.consolidateRules { (result) in
            
            if case .success(let data) = result {
                XCTAssert(data.count > 0 && data.count == rulesCount, "Rules not consolidated properly")
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 10)
    }
    
    func testWhenWritingRulesToContainerThenFileIsWritten() {
        
        let expectation = XCTestExpectation(description: "testWhenConsolidatingRulesThenRulesAreWrittenToContainer")
        
        let dummyList = DummyList(listStore: dummyStorage, networkClient: nil)
        let cbManager = ContentBlockerManager(listContainer: listContainer, contentBlockerHelper: contentBlockerHelper)
        dummyList.read { (result) in
            if case .success(let data) = result {
                do {
                    try cbManager.saveRulesToContainer(rules: data)
                    let sharedContainerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: cbManager.sharedContainerName)
                    guard let destinationURL = sharedContainerURL?.appendingPathComponent(cbManager.outputFileName) else { return }
                    if FileManager.default.fileExists(atPath: destinationURL.path) {
                        XCTAssert(true)
                        expectation.fulfill()
                    }
                } catch {
                    print("Error saving rules")
                }
            }
        }
        wait(for: [expectation], timeout: 10)
    }
}
