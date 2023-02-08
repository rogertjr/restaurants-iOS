//
//  XCTestCase+Ext.swift
//  RestaurantDomainTests
//
//  Created by Rogério Toledo on 08/02/23.
//


import XCTest
import RestaurantDomain

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "The instance should've been dealocated, possible memory leak", file: file, line: line)
        }
    }
    
    func makeItem() -> Restaurant {
        return Restaurant(id: UUID(), name: "name", location: "location", distance: 5.5, ratings: 0, parasols: 0)
    }
}
