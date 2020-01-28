//
//  FileStorageTests.swift
//  PepperTests
//
//  Created by Daniel Bernal on 17/10/19.
//  Copyright © 2019 Daniel Bernal. All rights reserved.
//

import XCTest
@testable import Pepper

class FileStorageTests: XCTestCase {
        
    let fileStore = FileListStore()
    let testPath = "test_data.json"
            
    func testWhenWritingJSONToAFileThenTheDataCanBeReadCorrectly() {

        let expectation = XCTestExpectation(description: "testWhenWritingJSONToAFileThenTheDataCanBeReadCorrectly")
        
        guard let data = "Some Sample Data".data(using: .utf8) else {
            return
        }
        
        fileStore.write(path: testPath, data: data) { writeResult in

            if case .success = writeResult {
                self.fileStore.read(path: self.testPath) { readResult in
                    if case .success(let writtenData) = readResult {
                        XCTAssertEqual(data, writtenData)
                        expectation.fulfill()
                    }
                }
            }
        }
        wait(for: [expectation], timeout: 10)
    }
}
