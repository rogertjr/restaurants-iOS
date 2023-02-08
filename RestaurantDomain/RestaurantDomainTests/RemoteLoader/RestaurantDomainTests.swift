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
    
    private func assert(
        _ sut: RemoteRestaurantLoader,
        description: String,
        completion result: RemoteRestaurantLoader.RemoteRestaurantLoaderResult,
        when action: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let expectation = expectation(description: description)
        var returnedResult: RemoteRestaurantLoader.RemoteRestaurantLoaderResult?
        
        sut.load { result in
            returnedResult = result
            expectation.fulfill()
        }
        
        action()

        XCTAssertEqual(returnedResult, result)
        wait(for: [expectation], timeout: 1.0)
    }
    
    private func emptyData() -> Data {
        return Data("{ \"items\": [] }".utf8)
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
        let (sut, client,  _) = try makeSUT()
        assert(sut, description: "Waiting error closure return", completion: .failure(.connectivity)) {
            client.completionWithError()
        }
    }
    
    func testLoadRemoteRestauranteLoaderReturnedErrorForInvalidData() throws {
        let (sut, client,  _) = try makeSUT()

        assert(sut, description: "Waiting error closure return", completion: .failure(.invalidData)) {
            client.completionWithSuccess()
        }
    }
    
    func testLoadRemoteRestauranteLoaderReturnedSuccessWithEmptyList() throws {
        let (sut, client,  _) = try makeSUT()
        
        assert(sut, description: "Waiting success closure return", completion: .success([])) {
            client.completionWithSuccess(data: emptyData())
        }
    }
    
    func testLoadRemoteRestauranteLoaderReturnedErrorForInvalidStatusCode() throws {
        let (sut, client,  _) = try makeSUT()

        assert(sut, description: "Waiting error closure return", completion: .failure(.invalidData)) {
            client.completionWithSuccess(201, data: emptyData())
        }
    }
}
