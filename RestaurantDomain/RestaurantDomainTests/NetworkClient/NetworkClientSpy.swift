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
    private (set) var completionHandler: ((NetworkState) -> Void)?
    
    // MARK: - Methods
    func request(from url: URL, completion: @escaping (NetworkState) -> Void) {
        urlRequest.append(url)
        completionHandler = completion
    }
    
    func completionWithError() {
        completionHandler?(.error(anyError()))
    }
    
    func completionWithSuccess() {
        completionHandler?(.success)
    }
    
    private func anyError() -> Error {
        return NSError(domain: "Any Error", code: -1)
    }
}
