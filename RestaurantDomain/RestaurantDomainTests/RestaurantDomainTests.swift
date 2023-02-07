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
    private func makeSUT() throws -> (
        sut: RemoteRestaurantLoader,
        client: NetworkClientSpy,
        anyURL: URL
    )  {
        let anyURL = try XCTUnwrap(URL(string: stringURL))
        let client = NetworkClientSpy()
        let sut = RemoteRestaurantLoader(anyURL, networkClient: client)
        return (sut, client, anyURL)
    }
    
    private func emptyData() -> Data {
        return Data("{ \"items\": [] }".utf8)
    }
    
    // MARK: - Tests
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
