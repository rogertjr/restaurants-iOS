//
//  NetworkServiceTests.swift
//  RestaurantDomainTests
//
//  Created by Rogério Toledo on 07/02/23.
//

import XCTest
@testable import RestaurantDomain

final class NetworkServiceTests: XCTestCase {
    // MARK: - Properties
    let urlString = "https://comitando.com.br"
    let anyError = NSError(domain: "Any error", code: -1)
    
    // MARK: - Tests
    func testLoadRequestResumeDataTaskWithUrl() throws {
        let url = try XCTUnwrap(URL(string: urlString))
        let session = URLSessionSpy()
        let task = URLSessionDataTaskSpy()
        let sut = NetworkService(session)
        
        session.stub(url, task: task)
        
        sut.request(from: url) { _ in }
        
        XCTAssertEqual(task.resumeCount, 1)
    }
    
    func testLoadRequestAndCompletionWithError() throws {
        let expectation = expectation(description: "Waiting error closure")
        let url = try XCTUnwrap(URL(string: urlString))
        let session = URLSessionSpy()
        let task = URLSessionDataTaskSpy()
        let sut = NetworkService(session)
        
        session.stub(url, task: task, error: anyError)
        
        sut.request(from: url) { [weak self] result in
            guard let self else { return }
            if case let .failure(returnedError) = result {
                XCTAssertEqual(returnedError as NSError, self.anyError)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}
