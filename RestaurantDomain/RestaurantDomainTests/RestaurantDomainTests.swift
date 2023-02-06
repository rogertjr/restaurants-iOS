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
        let anyURL = try XCTUnwrap(URL(string: "https://comitando.com.br"))
        let sut = RemoteRestaurantLoader(anyURL)
        
        sut.load()
        
        XCTAssertNotNil(NetworkClient.shared.urlRequest)
    }
}
