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
        
        sut.load()
        
        XCTAssertNotNil(client.urlRequest)
        XCTAssertEqual(client.urlRequest, anyURL)
    }
}
