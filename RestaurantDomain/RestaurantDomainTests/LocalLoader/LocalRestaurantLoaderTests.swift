//
//  LocalRestaurantLoaderTests.swift
//  RestaurantDomainTests
//
//  Created by Rogério Toledo on 08/02/23.
//

import XCTest
@testable import RestaurantDomain

final class LocalRestaurantLoaderTests: XCTestCase {
    // MARK: - Helpers
    private func makeSUT(
        _ currentDate: Date,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: LocalRestaurantLoader, cache: CacheClientSpy) {
        let cache = CacheClientSpy()
        let sut = LocalRestaurantLoader(cache, currentDate: { currentDate })
        
        trackForMemoryLeaks(cache)
        trackForMemoryLeaks(sut)
        
        return (sut, cache)
    }

    // MARK: - Tests
    func testSaveDeleteOldCache() {
        let currentDate = Date()
        let (sut, cache) = makeSUT(currentDate)
        let items = [Restaurant(id: UUID(), name: "name", location: "location", distance: 5.0, ratings: 0, parasols: 0)]
        
        sut.save(items, timestamp: Date()) { _ in }
        
        XCTAssertEqual(cache.methodsCalled, [.delete])
    }
    
    func testSaveInsertNewDataOnCache() {
        let currentDate = Date()
        let (sut, cache) = makeSUT(currentDate)
        let items = [Restaurant(id: UUID(), name: "name", location: "location", distance: 5.0, ratings: 0, parasols: 0)]
        
        sut.save(items, timestamp: Date()) { _ in }
        cache.completionHandlerForDelete(nil)
        
        XCTAssertEqual(cache.methodsCalled,
                       [.delete, .save(items: items, timestamp: currentDate)])
    }
}
