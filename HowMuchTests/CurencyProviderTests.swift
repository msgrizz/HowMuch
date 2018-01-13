//
//  CueencyProviderTests.swift
//  HowMuchTests
//
//  Created by Максим Казаков on 13/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import XCTest
@testable import HowMuch

class CueencyProviderTests: XCTestCase {
    
    let currencyProvider = CurrencyService.shared
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
//    currencyProvider
    
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
