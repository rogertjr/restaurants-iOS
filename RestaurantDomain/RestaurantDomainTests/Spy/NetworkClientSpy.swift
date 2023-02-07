//
//  NetworkClientSpy.swift
//  RestaurantDomainTests
//
//  Created by Rogério Toledo on 06/02/23.
//

import Foundation
import RestaurantDomain

final class NetworkClientSpy: NetworkClient {
    // MARK: - Properties
    private (set) var urlRequest: [URL] = []
    private (set) var completionHandler: ((NetworkResult) -> Void)?
    
    // MARK: - Methods
    func request(from url: URL, completion: @escaping (NetworkResult) -> Void) {
        urlRequest.append(url)
        completionHandler = completion
    }
    
    // MARK: - Helpers
    func completionWithError() {
        completionHandler?(.failure (anyError()))
    }
    
    func completionWithSuccess(_ statusCode: Int = 200, data: Data = Data()) {
        guard let responseStatus = HTTPURLResponse(url: urlRequest[0],
                                                   statusCode: statusCode,
                                                   httpVersion: nil,
                                                   headerFields: nil) else { return }
        completionHandler?(.success((data, responseStatus)))
    }
    
    private func anyError() -> Error {
        return NSError(domain: "Any Error", code: -1)
    }
}
