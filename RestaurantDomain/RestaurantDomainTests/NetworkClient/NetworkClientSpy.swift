//
//  NetworkClientSpy.swift
//  RestaurantDomainTests
//
//  Created by Rogério Toledo on 06/02/23.
//

import Foundation
@testable import RestaurantDomain

final class NetworkClientSpy: NetworkClient {
    // MARK: - Properties
    private (set) var urlRequest: [URL] = []
    
    // MARK: - Methods
    func request(from url: URL, completion: @escaping (Error) -> Void) {
        urlRequest.append(url)
        completion(anyError())
    }
    
    private func anyError() -> Error {
        return NSError(domain: "any erro", code: -1)
    }
}
