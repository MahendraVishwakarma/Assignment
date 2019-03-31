//
//  DatabaseTest.swift
//  AssignmentTests
//
//  Created by Mahendra Vishwakarma on 31/03/19.
//  Copyright © 2019 Mahendra Vishwakarma. All rights reserved.
//

import XCTest
@testable import Assignment

class DatabaseTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        
        self.measure {
            
        }
    }
    
    func testDBManager(){
        
        let obj = MyRealObject()
        obj.id =  10
        obj.structData = nil
        XCTAssertNotNil(obj)
        XCTAssertTrue(obj.id > 0)
        XCTAssertNil(obj.structData, "data can not be nil")
        
    }

}
