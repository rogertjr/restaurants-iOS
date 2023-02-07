//
//  RestaurantDomainTests.swift
//  RestaurantDomainTests
//
//  Created by Rogério Toledo on 06/02/23.
//

import XCTest
@testable import RestaurantDomain

final class RestaurantDomainTests: XCTestCase {
    // MARK: - Properties
    let stringURL = "https://comitando.com.br"
    
    // MARK: - SUT Factory
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) throws -> (
        sut: RemoteRestaurantLoader,
        client: NetworkClientSpy,
        anyURL: URL
    )  {
        let anyURL = try XCTUnwrap(URL(string: stringURL))
        let client = NetworkClientSpy()
        let sut = RemoteRestaurantLoader(anyURL, networkClient: client)
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, client, anyURL)
    }
    
    private func emptyData() -> Data {
        return Data("{ \"items\": [] }".utf8)
    }
    
    private func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "The instance should've been dealocated, possible memory leak", file: file, line: line)
        }
    }
    
    // MARK: - Tests
    func testLoadNotReutnedAfterSutDeallocated() throws {
        let anyURL = try XCTUnwrap(URL(string: stringURL))
        let client = NetworkClientSpy()
        var sut: RemoteRestaurantLoader? = RemoteRestaurantLoader(anyURL, networkClient: client)
        
        var returnedResult: RemoteRestaurantLoader.RemoteRestaurantLoaderResult?
        
        sut?.load { result in
            returnedResult = result
        }
        
        sut = nil
        
        client.completionWithSuccess()
        
        XCTAssertNil(returnedResult)
    }
    
    func testInitializerRemoteRestauranteLoaderAndValidateURLRequest() throws {
        let (sut, client, anyURL) = try makeSUT()
        
        sut.load() { _ in }
        
        XCTAssertNotNil(client.urlRequest)
        XCTAssertEqual(client.urlRequest, [anyURL])
        XCTAssertEqual(client.urlRequest.count, 1)
    }
    
    func testLoadRemoteRestauranteLoaderTwice() throws {
        let (sut, client, anyURL) = try makeSUT()
       
        sut.load() { _ in }
        sut.load() { _ in }
        
        XCTAssertNotNil(client.urlRequest)
        XCTAssertEqual(client.urlRequest, [anyURL, anyURL])
        XCTAssertEqual(client.urlRequest.count, 2)
    }
    
    func testLoadRemoteRestauranteLoaderReturnedErrorForConnectivity() throws {
        let expectation = expectation(description: "Waiting error closure return")
        let (sut, client,  _) = try makeSUT()
        
        var returnedResult: RemoteRestaurantLoader.RemoteRestaurantLoaderResult?
        
        sut.load { result in
            returnedResult = result
            expectation.fulfill()
        }
        
        client.completionWithError()
        
        XCTAssertEqual(returnedResult, .failure(.connectivity))
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testLoadRemoteRestauranteLoaderReturnedErrorForInvalidData() throws {
        let expectation = expectation(description: "Waiting error closure return")
        let (sut, client,  _) = try makeSUT()
        
        var returnedResult: RemoteRestaurantLoader.RemoteRestaurantLoaderResult?
        
        sut.load { result in
            returnedResult = result
            expectation.fulfill()
        }
        
        client.completionWithSuccess()
        
        XCTAssertEqual(returnedResult, .failure(.invalidData))
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testLoadRemoteRestauranteLoaderReturnedSuccessWithEmptyList() throws {
        let expectation = expectation(description: "Waiting success closure return")
        let (sut, client,  _) = try makeSUT()
        
        var returnedResult: RemoteRestaurantLoader.RemoteRestaurantLoaderResult?
        
        sut.load { result in
            returnedResult = result
            expectation.fulfill()
        }
        
        client.completionWithSuccess(data: emptyData())
        
        XCTAssertEqual(returnedResult, .success([]))
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testLoadRemoteRestauranteLoaderReturnedErrorForInvalidStatusCode() throws {
        let expectation = expectation(description: "Waiting error closure return")
        let (sut, client,  _) = try makeSUT()
        
        var returnedResult: RemoteRestaurantLoader.RemoteRestaurantLoaderResult?
        
        sut.load { result in
            returnedResult = result
            expectation.fulfill()
        }
        
        client.completionWithSuccess(201, data: emptyData())
        
        XCTAssertEqual(returnedResult, .failure(.invalidData))
        
        wait(for: [expectation], timeout: 1.0)
    }
}
