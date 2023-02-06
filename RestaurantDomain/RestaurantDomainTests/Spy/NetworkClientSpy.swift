//
//  NetworkClientSpy.swift
//  RestaurantDomainTests
//
//  Created by Rogério Toledo on 06/02/23.
//

import Foundation
@testable import RestaurantDomain

final class NetworkClientSpy: NetworkClient {
    private (set) var urlRequest: URL?
    
    func request(from url: URL) {
        urlRequest = url
    }
}
