//
//  URLSessionSpy.swift
//  RestaurantDomainTests
//
//  Created by Rogério Toledo on 07/02/23.
//

import Foundation
@testable import RestaurantDomain

final class URLSessionSpy: URLSession {
    // MARK: - Properties
    private (set) var stubs: [URL: Stub] = [:]
    
    struct Stub {
        let tasks: URLSessionDataTask
        let error: Error?
        let data: Data?
        let response: HTTPURLResponse?
    }
    
    // MARK: - Helpers
    func stub(
        _ url: URL,
        task: URLSessionDataTask,
        error: Error? = nil,
        data: Data? = nil,
        response: HTTPURLResponse? = nil
    ) {
        stubs[url] = Stub(tasks: task, error: error, data: data, response: response)
    }
    
    // MARK: - Overrides
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        guard let stub = stubs[url] else { return FakeURLSessionDataTask() }
        completionHandler(stub.data, stub.response, stub.error)
        
        return stub.tasks
    }
}

// MARK: - SPY
final class URLSessionDataTaskSpy: URLSessionDataTask {
    // MARK: - Properties
    private (set) var resumeCount = 0
    
    // MARK: - Overrides
    override func resume() {
        resumeCount += 1
    }
}

// MARK: - FAKE
final class FakeURLSessionDataTask: URLSessionDataTask {
    // MARK: - Overrides
    override func resume() { }
}
