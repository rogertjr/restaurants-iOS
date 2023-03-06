//
//  CacheClientSpy.swift
//  RestaurantDomainTests
//
//  Created by Rogério Toledo on 06/03/23.
//

import Foundation
@testable import RestaurantDomain

final class CacheClientSpy: CacheClient {
    // MARK: - Properties
    enum Methods: Equatable {
        case delete
        case save(items: [Restaurant], timestamp: Date)
    }
    
    private (set) var methodsCalled = [Methods]()
    private var completionHandler: ((Error?) -> Void)?
    
    // MARK: - Methods
    func save(_ items: [RestaurantDomain.Restaurant], timestamp: Date, completion: @escaping (Error?) -> Void) {
        methodsCalled.append(.save(items: items, timestamp: timestamp))
    }
    
    func delete(completion: @escaping (Error?) -> Void) {
        methodsCalled.append(.delete)
        completionHandler = completion
    }
    
    // MARK: - Helpers
    func completionHandlerForDelete(_ error: Error?) {
        completionHandler?(error)
    }
}
