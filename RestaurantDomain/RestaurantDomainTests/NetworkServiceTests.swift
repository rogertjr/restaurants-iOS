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
    
    // MARK: - Helpers
    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: NetworkClient, session: URLSessionSpy) {
        let session = URLSessionSpy()
        let sut = NetworkService(session)
        
        trackForMemoryLeaks(session)
        trackForMemoryLeaks(sut)
        
        return (sut, session)
    }
    
    private func assert(
        description: String,
        data: Data?,
        response: URLResponse?,
        error: Error?,
        file: StaticString = #filePath,
        line: UInt = #line
    ) throws -> NetworkService.NetworkResult? {
        let (sut, session) = makeSUT()
        let url = try XCTUnwrap(URL(string: urlString))
        let task = URLSessionDataTaskSpy()
        session.stub(url, task: task, error: error, data: data, response: response as? HTTPURLResponse)
        
        let exp = expectation(description: description)
        var returnedResult: NetworkService.NetworkResult?
        
        sut.request(from: url) { result in
            returnedResult = result
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        
        return returnedResult
    }
    
    private func resultErrorForInvalidCases(
        data: Data?,
        response: URLResponse?,
        error: Error?,
        file: StaticString = #filePath,
        line: UInt = #line
    ) throws -> Error? {
        
        let result = try assert(description: "waiting for error closure", data: data, response: response, error: error)
        
        switch result {
        case let .failure(error):
            return error
        default:
            XCTFail("Waiting for error, returned instead: \(String(describing: result))", file: file, line: line)
        }
        
        return nil
    }
    
    private func resultSuccessForValidCases(
        data: Data?,
        response: URLResponse?,
        error: Error?,
        file: StaticString = #filePath,
        line: UInt = #line
    ) throws -> (data: Data, response: HTTPURLResponse)? {
        
        let result = try assert(description: "waiting for success closure", data: data, response: response, error: error)
        
        switch result {
        case let .success((returnedData, returnedResponse)):
            return (returnedData, returnedResponse)
        default:
            XCTFail("Waiting for success, returned instead \(String(describing: result))", file: file, line: line)
        }
        
        return nil
    }
    
    // MARK: - Tests
    func testLoadRequestResumeDataTaskWithUrl() throws {
        let url = try XCTUnwrap(URL(string: urlString))
        let (sut, session) = makeSUT()
        let task = URLSessionDataTaskSpy()
        
        session.stub(url, task: task)
        
        sut.request(from: url) { _ in }
        
        XCTAssertEqual(task.resumeCount, 1)
    }
    
    func testLoadRequestAndCompletionWithErrorForInvalidCases() throws {
        let url = try XCTUnwrap(URL(string: urlString))
        let data = Data()
        let httpResponse = try XCTUnwrap(HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil))
        let urlResponse = URLResponse(url: url, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
        
        XCTAssertNotNil(try resultErrorForInvalidCases(data: nil, response: nil, error: nil))
        XCTAssertNotNil(try resultErrorForInvalidCases(data: nil, response: urlResponse, error: nil))
        XCTAssertNotNil(try resultErrorForInvalidCases(data: nil, response: httpResponse, error: nil))
        XCTAssertNotNil(try resultErrorForInvalidCases(data: data, response: nil, error: nil))
        XCTAssertNotNil(try resultErrorForInvalidCases(data: data, response: nil, error: anyError))
        XCTAssertNotNil(try resultErrorForInvalidCases(data: nil, response: urlResponse, error: anyError))
        XCTAssertNotNil(try resultErrorForInvalidCases(data: nil, response: httpResponse, error: anyError))
        XCTAssertNotNil(try resultErrorForInvalidCases(data: data, response: urlResponse, error: anyError))
        XCTAssertNotNil(try resultErrorForInvalidCases(data: data, response: httpResponse, error: anyError))
        
        let result = try resultErrorForInvalidCases(data: nil, response: nil, error: anyError)
        XCTAssertEqual(result as? NSError, anyError)
    }
    
    func testLoadRequestAndCompletionWithSuccessForValidCases() throws {
        let url = try XCTUnwrap(URL(string: urlString))
        let data = Data()
        let okResponse = 200
        let httpResponse = try XCTUnwrap(HTTPURLResponse(url: url, statusCode: okResponse, httpVersion: nil, headerFields: nil))
        
        let result = try resultSuccessForValidCases(data: data, response: httpResponse, error: nil)
        XCTAssertEqual(result?.data, data)
        XCTAssertEqual(result?.response.url, url)
        XCTAssertEqual(result?.response.statusCode, okResponse)
    }
}
