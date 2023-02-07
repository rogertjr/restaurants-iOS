//
//  RestaurantDomainTests.swift
//  RestaurantDomainTests
//
//  Created by Rogério Toledo on 06/02/23.
//

import XCTest
@testable import RestaurantDomain

final class RestaurantDomainTests: XCTestCase {
    
    func testInitializerRemoteRestauranteLoaderAndValidateURLRequest() throws {
        let stringURL = "https://comitando.com.br"
        let anyURL = try XCTUnwrap(URL(string: stringURL))
        let client = NetworkClientSpy()
        let sut = RemoteRestaurantLoader(anyURL, networkClient: client)
        
        sut.load() { _ in }
        
        XCTAssertNotNil(client.urlRequest)
        XCTAssertEqual(client.urlRequest, [anyURL])
        XCTAssertEqual(client.urlRequest.count, 1)
    }
    
    func testLoadRemoteRestauranteLoaderTwice() throws {
        let stringURL = "https://comitando.com.br"
        let anyURL = try XCTUnwrap(URL(string: stringURL))
        let client = NetworkClientSpy()
        let sut = RemoteRestaurantLoader(anyURL, networkClient: client)
        
        sut.load() { _ in }
        sut.load() { _ in }
        
        XCTAssertNotNil(client.urlRequest)
        XCTAssertEqual(client.urlRequest, [anyURL, anyURL])
        XCTAssertEqual(client.urlRequest.count, 2)
    }
    
    func testLoadRemoteRestauranteLoaderReturnedErrorForConnectivity() throws {
        let expectation = expectation(description: "Waiting error closure return")
        let stringURL = "https://comitando.com.br"
        let anyURL = try XCTUnwrap(URL(string: stringURL))
        let client = NetworkClientSpy()
        let sut = RemoteRestaurantLoader(anyURL, networkClient: client)
        
        var returnedError: Error?
        
        sut.load { error in
            returnedError = error
            expectation.fulfill()
        }
        
        XCTAssertNotNil(returnedError)
        
        wait(for: [expectation], timeout: 1.0)
    }
}
